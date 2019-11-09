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
    
    var textLeigth = Int()
    
    static func AttributeText(_size: CGFloat, color: UIColor, text: String, shadows: Bool) -> NSAttributedString {
        
        let langCode = LocalizationSystem.instance.getLanguage()
        var scaleRatio = CGFloat()
        
        switch langCode {
            case "ru": scaleRatio = 0.058
            case "en": scaleRatio = 0.08
            case "fr": scaleRatio = 0.07
            case "es": scaleRatio = 0.07
            case "zh": scaleRatio = 0.09
            default: break // scaleRatio = 0.09
        }
        
        let shadow = NSShadow()
        
        if shadows {
            shadow.shadowBlurRadius = 1
            shadow.shadowColor = UIColor.black
            shadow.shadowOffset = CGSize(width: 1.5, height: 1.5)
        }
        
        let stringAttributeText = [NSAttributedString.Key.font : UIFont(name: "junegull-regular",
                                                                        size: _size * scaleRatio)!,
                                   NSAttributedString.Key.shadow: shadow,
                                   NSAttributedString.Key.foregroundColor: color]
        let attributeText = NSAttributedString(string: text, attributes: stringAttributeText)
        
        return attributeText
    }

}


