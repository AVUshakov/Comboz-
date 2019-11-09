//
//  HelpView.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 24/12/2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class HelpView: UIView {
    
    var backImage = UIImageView()
    
    let stackView = UIStackView()
    
    let textView = UITextView()

    var imageLabels = [String : Int]()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "back_button"), for: .normal)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewSetup() {
        
        let image = "rules_frame_iphoneX"
        backImage.image = UIImage(named: image)
        backImage.frame = bounds
        addSubview(backImage)
        
        addSubview(textView)
        addSubview(backButton)
        
        textView.frame = CGRect(x: bounds.origin.x + bounds.width * 0.02,
                                y: bounds.origin.y + bounds.height * 0.02,
                                width: bounds.width * 0.97,
                                height: bounds.height * 0.84)
        
        backButton.frame.size = CGSize(width: bounds.width * 0.4, height: bounds.width * 0.15)
        backButton.frame.origin = CGPoint(x: bounds.midX - backButton.frame.width * 0.5, y: textView.bounds.maxY + ((bounds.maxY - textView.bounds.maxY) * 0.5) * 0.5)
        
        backButton.isEnabled = true
        backButton.isUserInteractionEnabled = true
        backButton.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "BACK", comment: ""), shadows: true), for: .normal)
        
        textView.isSelectable = false
        textView.isEditable = false
        textView.allowsEditingTextAttributes = false

        textView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)

        let attributedString = NSMutableAttributedString()
        
        let currentLang = LocalizationSystem.instance.getLanguage()
          
        switch currentLang {
        case "en":
            attributedString.setAttributedString(TextFont.AttributeText(_size: bounds.width * 0.5, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: load(file: "rulesEN"), shadows: false))
            imageLabels = ["ex1" : 672, "ex2" : 772, "ex3" : 908]
        case "ru":
            attributedString.setAttributedString(TextFont.AttributeText(_size: bounds.width * 0.55, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: load(file: "rulesRU"), shadows: false))
            imageLabels = ["ex1" : 678, "ex2" : 782, "ex3" : 911]
            
        case "es":
            attributedString.setAttributedString(TextFont.AttributeText(_size: bounds.width * 0.55, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: load(file: "rulesES"), shadows: false))
            imageLabels = ["ex1" : 727, "ex2" : 857, "ex3" : 1002]
        case "zh":
            attributedString.setAttributedString(TextFont.AttributeText(_size: bounds.width * 0.4, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: load(file: "rulesRU"), shadows: false))
            imageLabels = ["ex1" : 772, "ex2" : 234, "ex3" : 236]
        case "fr":
            attributedString.setAttributedString(TextFont.AttributeText(_size: bounds.width * 0.55, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: load(file: "rulesFR"), shadows: false))
            imageLabels = ["ex1" : 796, "ex2" : 948, "ex3" : 1101]
        default:
            break
        }

        attributedString.replaceCharacters(in: NSMakeRange(imageLabels["ex1"]!, 1), with: attrStringWithImage(string: "ex1", textView: textView) )
        attributedString.replaceCharacters(in: NSMakeRange(imageLabels["ex2"]!, 1), with: attrStringWithImage(string: "ex2", textView: textView) )
        attributedString.replaceCharacters(in: NSMakeRange(imageLabels["ex3"]!, 1), with: attrStringWithImage(string: "ex3", textView: textView)  )

        textView.attributedText = attributedString
    }
    
    @objc func closeView() {
        self.animatedRemove()
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
        UserDefaults.standard.set(false, forKey: "Purchase")
    }
    
    private func attrStringWithImage(string: String, textView: UITextView ) -> NSAttributedString {
        
        let textAtachment = NSTextAttachment()
        textAtachment.image = UIImage(named: string)
        
        let oldWidth = textAtachment.image!.size.width
        
        let scaleFactor = oldWidth/(textView.frame.size.width * 0.2)
        textAtachment.image = UIImage(cgImage: (textAtachment.image?.cgImage)!, scale: scaleFactor, orientation: .up)
        
        let attrStringWithImage = NSAttributedString(attachment: textAtachment)
     
        return attrStringWithImage
    }
    
    private func load(file name: String) -> String {
        if let path = Bundle.main.path(forResource: name, ofType: "txt") {
            if let contents = try? String(contentsOfFile: path) {
                return contents
            } else {
                print("Error! - This file doesn't contain any text.")
            }
        } else {
            print("Error! - This file doesn't exist.")
        }
        return ""
    }
    
    private func soundFXPlay(sound: String) {
        if !UserDefaults.standard.bool(forKey: "soundFX") {
            AudioController.sharedController.playFXSound(file: sound)
        }
    }

}
