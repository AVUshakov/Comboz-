//
//  CardsAnimation.swift
//  SetGame
//
//  Created by Alexander Ushakov on 08.06.2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class CardsAnimation: UIDynamicBehavior {
    
    override init() {
        super.init()
        addChildBehavior(cardBehavior)
    }
    
    lazy var cardBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        return behavior
    }()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
