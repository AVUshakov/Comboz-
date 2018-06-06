//
//  ViewController.swift
//  Set: Table Game
//
//  Created by Alexander Ushakov on 15.04.2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game = SetGameModel()
    
    private struct Colors {
        static let selectedCards = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        static let matchedCards = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        static let missMatchedCards = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewFromModel()
        
        
    }
    
    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet var gameOverLabel: UILabel!
    @IBOutlet var deal3CardsButton: UIButton!
    @IBOutlet var hintButton: UIButton!
    
    @IBAction func resetGameButton() {
        game = SetGameModel()
        for i in boardView.cardViews.indices {
            boardView.cardViews[i].isHidden = false
        }
        gameOverLabel.isHidden = true
        hintButton.isEnabled = true
        updateViewFromModel()
    }
    
    private func addTapRecognizer(for cardView: SetCardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(recognizedBy:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        cardView.addGestureRecognizer(tap)
    }
    
    @objc private func tapCard(recognizedBy recognizer: UITapGestureRecognizer){
        switch recognizer.state {
            case .ended:
                if let cardView = recognizer.view! as? SetCardView {
                    game.choosenCard(index: boardView.cardViews.index(of: cardView)!)
                    game.matchingResult()
                    minimizeAndDeleteAnimation()
                    deleteCardsFromView()
                }
            default:
                break
        }
        updateViewFromModel()
    }
    
    @IBAction func showHint() {
        game.showHintCard()
        if game.hintCards.isEmpty {
            hintButton.isEnabled = false
        }
        game.matchingResult()
        minimizeAndDeleteAnimation()
        deleteCardsFromView()
        updateViewFromModel()
    }
    
    @IBAction func deal3cards(_ sender: UIButton) {
        game.takeCardsFromDeck()
        updateViewFromModel()
    }
    
    private func deleteCardsFromView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.game.removeCards()
            self.hintButton.isEnabled = true
            self.boardView.cardViews.forEach{ $0.alpha = 1}
            self.updateViewFromModel()
        })
    }
    
    private func minimizeAndDeleteAnimation() {
        
        var cardsForFlip = [SetCardView]()
        
        print(cardsForFlip.count)
        
        for index in game.cardsOnTable.indices {
            let card = game.cardsOnTable[index]
            if card.isFaceUp == false {
                cardsForFlip.append(boardView.cardViews[index])
            }
        }
        
        cardsForFlip.forEach { cardView in
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1.0,
                    delay: 0,
                    options: [],
                    animations: { cardView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                  cardView.alpha = 0 },
                    completion: { position in
                        cardView.transform = .identity })

//                UIView.transition(with: cardView,
//                                  duration: 0.5,
//                                  options: [.transitionFlipFromTop],
//                                  animations: {cardView.isFaceUp = !cardView.isFaceUp
//                                    cardView.alpha = 0},
//
//                                  completion: nil)
        }
    }
        
    
    private func updateViewFromModel(){
        updateCardsViewFromModel()
        
    }
    
    private func updateCardsViewFromModel() {
        if boardView.cardViews.count - game.cardsOnTable.count > 0 {
            let cardViews = boardView.cardViews[..<game.cardsOnTable.count]
            boardView.cardViews = Array(cardViews)
        }
        let numberCardView = boardView.cardViews.count
        
        for index in game.cardsOnTable.indices {
            let card = game.cardsOnTable[index]
            if index > (numberCardView - 1) {
                let cardView = SetCardView()
                updateCardView(cardView, for: card)
                addTapRecognizer(for: cardView)
                boardView.cardViews.append(cardView)
            } else {
                let cardView = boardView.cardViews[index]
                updateCardView(cardView, for: card)
            }
        }
        if game.endGameDetector {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                
                for i in self.boardView.cardViews.indices {
                    self.boardView.cardViews[i].isHidden = true
                    //self.cardButtons[i].isEnabled = false
                }
                self.gameOverLabel.isHidden = false
                self.hintButton.isEnabled = false
            })
        }
        
    }
    
    private func updateCardView(_ cardView: SetCardView, for card: Card) {
        
        cardView.symbolType = card.shape.rawValue
        cardView.fillType = card.fill.rawValue
        cardView.colorType = card.color.rawValue
        cardView.count = card.count.rawValue
        cardView.isSelected = game.selectedCards.contains(card)
        //cardView.isFaceUp = card.isFaceUp
        
        if let setDetector = game.setDetector {
            if game.cardForMatching.contains(card) {
                cardView.isMatched = setDetector
            }
        } else {
            cardView.isMatched = nil
        }
    }
}



extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

