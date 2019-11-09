//
//  AnimatedView.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 03/06/2019.
//  Copyright © 2019 Alexander Ushakov. All rights reserved.
//

import UIKit

class AnimatedView: UIView {
    
    var image = String()
    var backgroundView1 = UIImageView()
    var backgroundView2 = UIImageView()
    
    
    
    func setBackgrounds() {
        print("height \(UIScreen.main.bounds.height)")
        
        if UIDevice().userInterfaceIdiom == .phone
        {
            switch UIScreen.main.bounds.height {
            case 812: //iphoneX
                image = "animate_bg_iphoneX"
            case 896: //iphoneXS
                image = "animate_bg_iphonePlus"
            case 736: //iphonePlus
                image = "animate_bg_iphonePlus"
                print("IPHONE+")
            case 667: //iphone4.7
                image = "animate_bg_iphone"
            default:
                image = "animate_bg_iphoneSE"
            }
        } else if UIDevice().userInterfaceIdiom == .pad {
                image = "symbols_ipad"
        }
        
        if let background = UIImage(named: image) {
            backgroundView1 = UIImageView(image: background)
            backgroundView2 = UIImageView(image: background)
            backgroundView1.contentMode = .scaleAspectFill
            backgroundView2.contentMode = .scaleAspectFill
            self.addSubview(backgroundView1)
            self.addSubview(backgroundView2)
        }
    }
    
    func animateBackground() {
        
//        backgroundView1.frame = frame
//        backgroundView2.frame = CGRect(x: frame.origin.x, y: backgroundView1.frame.size.height, width: frame.width, height: frame.height)
//
//        UIView.animate(withDuration: 80.0, delay: 0.0,
//                       options: [.repeat, .curveLinear],
//                       animations: {
//                        self.backgroundView1.frame = self.backgroundView1.frame.offsetBy(dx: 0.0, dy: -1 * self.backgroundView1.frame.size.height)
//                        self.backgroundView2.frame = self.backgroundView2.frame.offsetBy(dx: 0.0, dy: -1 * self.backgroundView2.frame.size.height)
//                        },
//                       completion: nil)
    }
}
