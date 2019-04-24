//
//  FontAttributes.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 23/04/2019.
//  Copyright © 2019 Alexander Ushakov. All rights reserved.
//

import Foundation
import UIKit

class TextFont: NSAttributedString {
    
//    static let stringAttributeText = TextFont()
    
    static func AttributeText(_size: CGFloat, color: UIColor, text: String) -> NSAttributedString {
        
    let shadow = NSShadow()
        shadow.shadowBlurRadius = 1
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        
        let stringAttributeText = [NSAttributedString.Key.font : UIFont(name: "junegull-regular", size: _size)!,
                                   NSAttributedString.Key.shadow: shadow,
                                   NSAttributedString.Key.foregroundColor: color]

        let attributeText = NSAttributedString(string: text, attributes: stringAttributeText)
        
        return attributeText
    }

    
}
