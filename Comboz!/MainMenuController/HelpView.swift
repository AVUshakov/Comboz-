//
//  HelpView.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 24/12/2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class HelpView: UIView {
    
    let textView = UITextView()

    var imageLabels = [String : Int]()
    
    var closeViewButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "Back_button"), for: .normal)
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
        
        backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    
        closeViewButton.frame.size = CGSize(width: bounds.width * 0.1, height: bounds.width * 0.1)
        closeViewButton.frame.origin = CGPoint(x: bounds.maxX - closeViewButton.frame.width - 2, y: bounds.minY + 2)
                
        closeViewButton.isEnabled = true
        closeViewButton.isUserInteractionEnabled = true
        
        textView.isSelectable = false
        textView.isEditable = false
        textView.allowsEditingTextAttributes = false
        textView.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 16.0)
        textView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        textView.textColor = #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1)
        
        textView.frame = CGRect(origin: CGPoint(x: self.bounds.origin.x + 10, y: self.bounds.origin.y + 40) , size: CGSize(width: self.bounds.width - 20, height: self.bounds.height - 40))

        var attributedString = NSMutableAttributedString()
        
        let langStr = Locale.current.languageCode
        
        print(langStr!)
        
        switch langStr {
        case "en":
            attributedString = NSMutableAttributedString(string: load(file: "rules"))
            imageLabels = ["label1" : 772, "label2" : 904, "label3" : 1052]
        case "ru":
            attributedString = NSMutableAttributedString(string: load(file: "rulesRU"))
            imageLabels = ["label1" : 12, "label2" : 234, "label3" : 236]
        default:
            break
        }

        let textAtachment = NSTextAttachment()
        textAtachment.image = UIImage(named: "label1")

        let oldWidth = textAtachment.image!.size.width

        let scaleFactor = oldWidth/(textView.frame.size.width * 0.3)
        textAtachment.image = UIImage(cgImage: (textAtachment.image?.cgImage)!, scale: scaleFactor, orientation: .up)

        let attrStringWithImage = NSAttributedString(attachment: textAtachment)

        attributedString.replaceCharacters(in: NSMakeRange(imageLabels["label1"]!, 1), with: attrStringWithImage)
        attributedString.replaceCharacters(in: NSMakeRange(imageLabels["label2"]!, 1), with: attrStringWithImage)
        attributedString.replaceCharacters(in: NSMakeRange(imageLabels["label3"]!, 1), with: attrStringWithImage)

        textView.attributedText = attributedString
       // addSubview(textView)
        self.addSubview(closeViewButton)


        
    }
    
    @objc func closeView() {
        self.animatedRemove()
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    private func load(file name:String) -> String {
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
