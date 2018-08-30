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
    
    var matchedCardsSet: [SetCardView] {
        return boardView.cardViews.filter { $0.isFaceUp == false }
    }
    
    var cardsForDeal: [SetCardView] {
        return boardView.cardViews.filter { $0.alpha == 0 }
    }

    var dealCompleted = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    @IBOutlet weak var boardView: BoardView! 

    @IBOutlet weak var deckView: SetCardView!
        {
        didSet {
                deckView.alpha = 0
            
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
//        game = SetGameModel()
//        for i in boardView.cardViews.indices {
//            boardView.cardViews[i].isHidden = false
//        }
//        gameOverLabel.isHidden = true
//        hintButton.isEnabled = true
//        updateViewFromModel()
//
//   flipCradAnimation(for: boardView.cardViews)
//        game.flipCards()
//        updateViewFromModel()
    
        
        
        
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
                    self.hintButton.isEnabled = true
                    if game.setDetector != nil && !game.setDetector! {
                       DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.deleteCardsFromView()
                       })
                    }
                }
            default:
                break
        }
        updateViewFromModel()
        
    }
    
    @IBAction func showHint() {
        game.showHintCard()
        if game.hintCards.isEmpty && !dealCompleted {
            hintButton.isEnabled = false
        }
        game.matchingResult()
        updateViewFromModel()
    }
    
    @IBAction func deal3cards(_ sender: UIButton) {
        //game.takeCardsFromDeck()
        //dealCompleted = true
        snaping()
        //updateViewFromModel()

    }
    
    private func deleteCardsFromView() {
        game.removeCards()
        
        updateViewFromModel()
    }
    
    private func minimizeAndDeleteAnimation() {

        var cardsForScale: [SetCardView] {
            var cardsForScale = [SetCardView]()
            var tmpCard = SetCardView()
            for index in game.cardsOnTable.indices {
                let card = game.cardsOnTable[index]
                if !card.isFaceUp {
                    tmpCard = boardView.cardViews[index].copyCard()
                    tmpCard.isMatched = true
                    tmpCard.isFaceUp = true
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
                options: UIViewAnimationOptions.curveEaseInOut,
                animations: { cardView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                    cardView.alpha = 0
                    
            },
                completion: { position in
                    
                    self.deleteCardsFromView()
                    
                    cardView.removeFromSuperview()
                    self.dealCardsAnimation()
                }
            )
        }
    }
    
  
    private func updateViewFromModel() {
        updateCardsViewFromModel()
    }
    
    private func updateCardsViewFromModel() {
    
        var newCardViews = [SetCardView] ()
        if boardView.cardViews.count - game.cardsOnTable.count > 0 {
            boardView.removeCardsView(cardsViewForRemove: matchedCardsSet)
        }
        let numberCardView = boardView.cardViews.count
        
        for index in game.cardsOnTable.indices {
            let card = game.cardsOnTable[index]
            if index > (numberCardView - 1) {
                let cardView = SetCardView()
                updateCardView(cardView, for: card)
                cardView.alpha = 0
                cardView.frame.origin = deckView.frame.origin
                addTapRecognizer(for: cardView)
                newCardViews += [cardView]
            } else {
                let cardView = boardView.cardViews[index]
                updateCardView(cardView, for: card)
            }
        }
        boardView.addCardsView(newCardsView: newCardViews)

        if matchedCardsSet.isEmpty && dealCompleted {
            
            dealCardsAnimation()
        } else {
            minimizeAndDeleteAnimation()
            
        }
        
        
        
        if game.endGameDetector {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                
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

    private func dealCardsAnimation() {
        var currentCardsForDeal = 0
        let dealInterval = 0.15 * Double(boardView.gridRows + 1)
        Timer.scheduledTimer(withTimeInterval: dealInterval, repeats: false) {
            timer in
            self.cardsForDeal.forEach{ cardView in
                cardView.dealCardsFromDeckAnimation(from: self.deckView.center, delay: TimeInterval(currentCardsForDeal) * 0.25)
                currentCardsForDeal += 1
            }
        }
        dealCompleted = false
    }
    
    
    
    private func snaping(){
        
        
        boardView.cardViews.forEach{ card in
            var snapPoint: CGPoint {
                return view.convert(card.frame.origin, to: boardView)
            }
            let snap = UISnapBehavior(item: card, snapTo: snapPoint)
            snap.damping = 0.2
            self.animator.addBehavior(snap)
            
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

