//
//  BoardView.swift
//  Set: Table Game
//
//  Created by Alexander Ushakov on 19.05.2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    var cardViews = [SetCardView]() {
        willSet  { removeSubviews() }
        didSet { addSubview(); setNeedsLayout() }
    }
    
    private func removeSubviews() {
        for card in cardViews {
            card.removeFromSuperview()
        }
    }
    
    private func addSubview() {
        for card in cardViews {
            addSubview(card)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: Grid.Layout.aspectRatio(Constants.cellRatio), frame: bounds)
        grid.cellCount = cardViews.count
        if grid.cellCount >= 12 {
        for row in 0..<grid.dimensions.rowCount {
            for column in 0..<grid.dimensions.columnCount {
                if cardViews.count > (row * grid.dimensions.columnCount + column) {
                    cardViews[row * grid.dimensions.columnCount + column].frame = grid[row,column]!.insetBy(dx: Constants.spacingDx, dy: Constants.spacingDy)
                    }
            }
        }
        }
    }

    struct Constants {
        static let cellRatio: CGFloat = 0.625
        static let spacingDx: CGFloat = 2.0
        static let spacingDy: CGFloat = 2.0
    }

}
