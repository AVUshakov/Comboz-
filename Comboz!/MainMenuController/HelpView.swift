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

    var imageLabels = ["label1" : 772, "label2" : 904, "label3" : 1052]
    
    var closeViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back_button"), for: .normal)
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
        
        self.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        textView.isSelectable = false
        textView.isEditable = false
        textView.allowsEditingTextAttributes = false
        textView.frame = CGRect(origin: CGPoint(x: self.bounds.origin.x + 10, y: self.bounds.origin.y + 10) , size: CGSize(width: self.bounds.width - 20, height: self.bounds.height - 20))

        textView.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 16.0)
        textView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        textView.textColor = #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1)

        let attributedString = NSMutableAttributedString(string: load(file: "rules"))

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

        self.addSubview(textView)
        
        closeViewButton.frame.size = CGSize(width: frame.width / 10, height: frame.width / 10)
        closeViewButton.frame.origin = CGPoint(x: bounds.maxX - closeViewButton.frame.width, y: bounds.minY)
        addSubview(closeViewButton)
    }
    
    @objc func closeView() {
        self.animatedRemove()
    }
    
    func load(file name:String) -> String {
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

}
