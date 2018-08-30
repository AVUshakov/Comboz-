//
//  BoardView.swift
//  Set: Table Game
//
//  Created by Alexander Ushakov on 19.05.2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    var cardViews = [SetCardView]()

    var gridRows:Int { return gridCards?.dimensions.rowCount ?? 0 }
    private var gridCards: Grid?
    
    private func layoutSetCard() {
        if let grid = gridCards {
        if grid.cellCount >= 12 {
            for row in 0..<gridRows {
                for column in 0..<grid.dimensions.columnCount {
                    if cardViews.count > (row * grid.dimensions.columnCount + column) {
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                                       delay: TimeInterval(column + row) * 0.2,
                                                                       options: [.curveEaseInOut],
                                                                       animations: {
                                                                        self.cardViews[row * grid.dimensions.columnCount + column].frame = grid[row,column]!.insetBy(dx: Constants.spacingDx, dy: Constants.spacingDy)

                    },completion: nil)
                        }
                    }
                }
            }
        }
    }
    func removeCardsView(cardsViewForRemove: [SetCardView]) {
        cardsViewForRemove.forEach{ (cardView) in
            cardViews.removeArray(elements: [cardView])
            cardView.removeFromSuperview()
        }
        layoutIfNeeded()
    }
    
    func addCardsView(newCardsView: [SetCardView]) {
        cardViews += newCardsView
        newCardsView.forEach{ (cardView) in
            addSubview(cardView)
        }
        layoutIfNeeded()
    }
    
    func resetAllCards() {
        cardViews.forEach{ (cardView) in
            cardView.removeFromSuperview()
        }
        cardViews = []
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gridCards = Grid(layout: Grid.Layout.aspectRatio(Constants.cellRatio), frame: bounds)
        gridCards?.cellCount = cardViews.count
        layoutSetCard()
    }

    
    struct Constants {
        static let cellRatio: CGFloat = 0.625
        static let spacingDx: CGFloat = 2.0
        static let spacingDy: CGFloat = 2.0
    }

}
