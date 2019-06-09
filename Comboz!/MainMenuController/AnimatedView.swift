//
//  AnimatedView.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 03/06/2019.
//  Copyright © 2019 Alexander Ushakov. All rights reserved.
//

import UIKit

class AnimatedView: UIView {

    var imageViews = [CardView]()
    
    var gridRows: Int { return gridViews?.dimensions.rowCount ?? 0 }
    
    private var gridViews: ScreenGrid?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addView()
        animationBackground()
    }
    
    func animationBackground() {
        self.imageViews.forEach { view in
            let rand = self.imageViews.count.arc4random
            view.inviseView(delay: TimeInterval(rand))
        }
    }
        
    
    func addView() -> () {
        for _ in 0...14 {
            var array = [CardView]()
            for i in 0...2 {
                let shape = CardView()
                shape.cardBackgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                shape.colorType = 4
                shape.fillType = 3
                shape.count = 1
                shape.isFaceUp = true
                shape.alpha = 0.2
                shape.symbolType = i + 1
                array.append(shape)
            }
            imageViews += array
        }
        imageViews.forEach{ (view) in
            view.center = CGPoint(x: bounds.midX, y: bounds.maxY + view.bounds.size.height)
            addSubview(view)
        }
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gridViews = ScreenGrid(layout: ScreenGrid.Layout.aspectRatio(Constants.cellRatio), frame: bounds)
        gridViews!.cellCount = imageViews.count
        for row in 0..<gridRows {
            for column in 0..<gridViews!.dimensions.columnCount {
                if imageViews.count > (row * gridViews!.dimensions.columnCount + column) {
                    imageViews[row * gridViews!.dimensions.columnCount + column].frame = gridViews![row,column]!.insetBy(dx: Constants.spacingDx, dy: Constants.spacingDy)
                }
            }
        }
    }
    
    struct Constants {
        static let cellRatio: CGFloat = 0.9
        static let spacingDx: CGFloat = 1.0
        static let spacingDy: CGFloat = 1.0
    }
}
