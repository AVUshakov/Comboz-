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
    
    let defaults = UserDefaults.standard
    
    var gameModelJSON: SetGameModel? {
        get {
            if  let savedGameModel = defaults.object(forKey: "SavedGameModel") as? Data {
                let decoder = JSONDecoder()
                if let loadedGameModel = try? decoder.decode(SetGameModel.self, from: savedGameModel) {
                    return loadedGameModel
                }
            }
            return nil
        }
        set {
            if newValue != nil {
                let encoder = JSONEncoder()
                if let json = try? encoder.encode(newValue!) {
                    defaults.set(json, forKey: "SavedGameModel")
                }
            }
        }
    }
    
    @IBOutlet weak var backgroundVIew: UIImageView!

    @IBOutlet weak var score: UILabel!
    
    @IBAction func returnToMainMEnu(_ sender: UIButton) {
        let mainMenuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenuController")
        mainMenuVC.modalPresentationStyle = .fullScreen
        mainMenuVC.modalTransitionStyle = .crossDissolve
        self.present(mainMenuVC, animated: true, completion: nil )
    }

    var matchedCardsSet: [SetCardView] {
        return boardView.cardViews.filter { $0.isFaceUp == false }
    }
    
    var cardsForDeal: [SetCardView] {
        return boardView.cardViews.filter { $0.alpha == 0 }
    }

    var dealCompleted = true
    
    var timer = Timer()
    var timerIsRunnning = false
    var counter = 0.0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gameModelJSON = game
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let gameFROM = gameModelJSON {
            game = gameFROM
            updateViewFromModel()
        } else {
            game = SetGameModel()
        }
        addParallaxToView(view: backgroundVIew)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewFromModel()
        
    }
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet var gameOverLabel: UILabel!
    
    @IBOutlet var deal3CardsButton: UIButton!
    
    @IBOutlet var hintButton: UIButton!
    
    
    
    @IBAction func resetGameButton() {
        defaults.removeSuite(named: "SavedGameModel")
        gameModelJSON = nil
        game = SetGameModel()
        
        gameOverLabel.isHidden = true
        hintButton.isEnabled = true
        dealCompleted = true

        updateViewFromModel()
        if gameModelJSON == nil {
            print("nil")}
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
        game.takeCardsFromDeck()
        dealCompleted = true
        updateViewFromModel()
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    private func startTimer() {
        if !timerIsRunnning {
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(runTimer),
                                         userInfo: nil,
                                         repeats: true)
            timerIsRunnning = true
        }
    }
    
    @objc func runTimer() {
        counter += 0.1
        let flooredCounter = Int(floor(counter))
        
        let hour = flooredCounter / 3600
        let minute = (flooredCounter % 3600) / 60
        let second = (flooredCounter % 3600) % 60
        
        var minuteString = "\(minute)"
        if minute < 10 {
            minuteString = "0\(minute)"
        }
        
        var secondString = "\(second)"
        if second < 10 {
                    secondString = "0\(second)"
        }
        
        timerLabel.text = "\(hour):\(minuteString):\(secondString)"
    }
    
    private func deleteCardsFromView() {
        game.removeCards()
        updateViewFromModel()
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
                }
                self.gameOverLabel.isHidden = false
                self.hintButton.isEnabled = false
            })
        }
        score.text = "Left: \(game.cardsDeckCount)"
    }
    
    private func addParallaxToView(view: UIImageView) {
        
        let screenSize = view.bounds.size
        view.bounds.size = CGSize(width: screenSize.width * 1.2, height: screenSize.height * 1.2)
        
        let amount = 20
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        view.addMotionEffect(group)
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
                withDuration: 0.4,
                delay: 0.7,
                options: UIView.AnimationOptions.curveEaseInOut,
                animations: { cardView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                    cardView.alpha = 0
            },
                completion: { position in
                    self.deleteCardsFromView()
                    cardView.removeFromSuperview()
                    self.dealCardsAnimation()
            })
        }
    }

    private func dealCardsAnimation() {
        var currentCardsForDeal = 0
        
        let dealInterval = 0.03 * Double(boardView.gridRows + 1)
        Timer.scheduledTimer(withTimeInterval: dealInterval, repeats: false) {
            timer in
            self.cardsForDeal.forEach { cardView in
                let dealPoint = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.maxY + cardView.bounds.height)
                if self.gameModelJSON == nil {
                    cardView.dealCardsFromDeckAnimation(from: dealPoint,delay: TimeInterval(currentCardsForDeal) * 0.25)
                } else {
                    cardView.dealCardsFromDeckWithouAnimation(from: dealPoint)
                }
                currentCardsForDeal += 1
               
            }
        }
        Timer.scheduledTimer(withTimeInterval: Double(cardsForDeal.count) * 0.25, repeats: false) {_ in
            self.startTimer()
        }
        dealCompleted = false
        
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


