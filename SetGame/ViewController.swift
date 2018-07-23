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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        
    }
    
    @IBOutlet weak var boardView: BoardView!

    @IBOutlet weak var deckView: SetCardView!
        {
        didSet {
                deckView.alpha = 0
//                deckView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
////                boardView.addSubview(deckView)
////                deckView.frame.origin = boardView.bounds.origin
//           // if boardView.cardViews.count > 0 { deckView = boardView.cardViews[1].copyCard() }
//                //deckView.isFaceUp = false
            
                let tap = UITapGestureRecognizer(target: self, action: #selector(animation))
                tap.numberOfTapsRequired = 1
                tap.numberOfTouchesRequired = 1
                deckView.addGestureRecognizer(tap)
            }
      }

    @objc private func animation(){
        print("touched")
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 2.0,
            delay: 0,
            options: [],
            animations: {
               
                
                 },
            completion: nil)

    }
   
    
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
        
        
        boardView.cardViews.forEach{ card in
            if !card.isFaceUp {
                print("ok")
                UIView.transition(with: card, duration: 3, options: .transitionFlipFromLeft, animations: { card.isFaceUp = !card.isFaceUp }, completion: nil)
            }
        }
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
                    if game.setDetector != nil && !game.setDetector! {
                       DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.deleteCardsFromView() })
                    }
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
        
        
        updateViewFromModel()
    }
    
    @IBAction func deal3cards(_ sender: UIButton) {
        print(boardView.cardViews.count)
        boardView.cardViews.forEach{ print($0.frame.size)}
//        var oldCards = [SetCardView]()
//        boardView.cardViews.forEach { card in
//            let tmpCard = card.copyCard()
//            oldCards.append(tmpCard)
//            //boardView.addSubview(tmpCard)
//            card.alpha = 1
//         //   print(card.frame.size)
//        }
        game.takeCardsFromDeck()
        updateViewFromModel()
        
        print(boardView.cardViews.count)
        
        boardView.cardViews.forEach{ print($0.frame.size)}
        
    }
    


    private func deleteCardsFromView() {
            self.game.removeCards()
            self.hintButton.isEnabled = true
            self.boardView.cardViews.forEach {$0.alpha = 1}
            self.updateViewFromModel()
    }
    
//    private func animationOfDealCards() {
//
//        for index in self.boardView.cardViews.indices {
//            let card = self.boardView.cardViews[index]
//            if !card.isFaceUp {
//                let tmpCard = card.copyCard()
//                tmpCard.frame.origin = self.deckView.frame.origin
//                tmpCard.isSelected = false
//                tmpCard.alpha = 1
//                self.boardView.addSubview(tmpCard)
//                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1,
//                                                               delay: 0,
//                                                               options: [],
//                                                               animations: { tmpCard.frame.origin = self.boardView.cardViews[index].frame.origin },
//                                                               completion: { position in
//                                                                            //tmpCard.removeFromSuperview()
//                                                                            UIView.transition(with: tmpCard,
//                                                                                              duration: 0.5,
//                                                                                              options: [.transitionFlipFromLeft],
//                                                                                              animations: { tmpCard.isFaceUp = true
//                                                                                                self.boardView.cardViews[index].isFaceUp = true },
//                                                                                              completion: {finished in
//                                                                                                    self.boardView.cardViews[index].alpha = 1
//                                                                                                    tmpCard.removeFromSuperview()
//                                                                                                    self.updateViewFromModel()
//                                                                            })
//                                                                })
//
//            }
//        }
//    }

    private func minimizeAndDeleteAnimation() {
        var cardsForScale: [SetCardView] {
            var cardsForScale = [SetCardView]()
            var tmpCard = SetCardView()
            for index in game.cardsOnTable.indices {
                let card = game.cardsOnTable[index]
                if !card.isFaceUp {
                    tmpCard = boardView.cardViews[index].copyCard()
                    tmpCard.isMatched = true
                    cardsForScale.append(tmpCard)
                    boardView.addSubview(tmpCard)
                    boardView.cardViews[index].alpha = 0
                    }
                }
            return cardsForScale
        }
        
        cardsForScale.forEach { cardView in
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5,
                    delay: 0.7,
                    options: [UIViewAnimationOptions.curveEaseInOut],
                    animations: { cardView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                        cardView.alpha = 0 },
                    completion: { position in
                        self.deleteCardsFromView()
                        cardView.removeFromSuperview()
                        self.updateViewFromModel()
                        for index in self.boardView.cardViews.indices {
                            let card = self.boardView.cardViews[index]
                            if !card.isFaceUp {
                                let tmpCard = card.copyCard()
                                tmpCard.frame.origin = self.deckView.frame.origin
                                tmpCard.alpha = 1
                                card.alpha = 0
                                self.boardView.addSubview(tmpCard)
                                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6,
                                                                               delay: 0,
                                                                               options: [UIViewAnimationOptions.curveEaseInOut],
                                                                               animations: {tmpCard.frame.origin = self.boardView.cardViews[index].frame.origin },
                                                                               completion: { position in
                                                                                UIView.transition(with: tmpCard,
                                                                                                  duration: 0.4,
                                                                                                  options: [.transitionFlipFromLeft],
                                                                                                  animations: {tmpCard.isFaceUp = true
                                                                                                    self.boardView.cardViews[index].isFaceUp = true },
                                                                                                  completion: {finished in
                                                                                                    self.boardView.cardViews[index].alpha = 1
                                                                                                    tmpCard.removeFromSuperview()
                                                                                                    self.game.flipCards() }
                                                                                                )
                                                                                }
                                )
                            }
                        }
                })
        }
    }
        
    
    private func updateViewFromModel() {
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
        cardView.isFaceUp = card.isFaceUp
        
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

