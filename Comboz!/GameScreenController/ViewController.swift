//
//  ViewController.swift
//  Set: Table Game
//
//  Created by Alexander Ushakov on 15.04.2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    var game = GameModel()
    
    var inScreenViewRect: CGRect?
    
    var pauseView: PauseView?
    
    var endGameView: EndGameView?
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    let defaults = UserDefaults.standard
    
    var gameModelJSON: GameModel? {
        get {
            if  let savedGameModel = defaults.object(forKey: "SavedGameModel") as? Data {
                let decoder = JSONDecoder()
                if let loadedGameModel = try? decoder.decode(GameModel.self, from: savedGameModel) {
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
    
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var score: UILabel!
    
    @IBAction func pauseButton(_ sender: UIButton) {
        pauseViewAdding()
    }
    
    @IBOutlet weak var timeBonusLabel: UILabel!
    
    private func timeBonusAnimation() {
        let point = timeBonusLabel.center
        timeBonusLabel.center = CGPoint(x: view.center.x, y: view.frame.minY - score.frame.height)
        timeBonusLabel.isHidden = false
        timeBonusLabel.blinkEffect()
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                       delay: 0,
                                                       options: [.curveEaseInOut],
                                                       animations: { self.timeBonusLabel.center = point },
                                                       completion: {finished in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(1.6)), execute:
                { self.timeBonusLabel.isHidden = true
                    self.timeBonusLabel.alpha = 0
            })
        })
    }
    
    var matchedCardsSet: [CardView] {
        return boardView.cardViews.filter { $0.isFaceUp == false }
    }
    
    var cardsForDeal: [CardView] {
        return boardView.cardViews.filter { $0.alpha == 0 }
    }
    
    var cardsForDelete: [CardView] {
        return boardView.cardViews.filter {$0.isFaceUp == true}
    }
    
    var dealCompleted = true

    var timer = Timer()
    var timerIsRunnning = false
    var touchCounter = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gameModelJSON = game
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let gameFROM = gameModelJSON {
            game = gameFROM
            game.gameIsResume = true
            updateViewFromModel()
        }
        addParallaxToView(view: backgroundView)
        blurEffectView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if view.window != nil {
            inScreenViewRect = CGRect(x: (view.frame.width - view.frame.width * 0.8) / 2,
                                      y: (view.frame.height - view.frame.height * 0.8) / 2,
                                      width: view.frame.width * 0.8,
                                      height: view.frame.height * 0.8)
        }
    }
    
    override func viewWillLayoutSubviews() {
        blurController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(backgroundPauseView), name: NSNotification.Name("goToBackground"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       
    }
    
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet var deal3CardsButton: UIButton!
    
    @IBOutlet var hintButton: UIButton! {
        didSet {
            hintButton.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.2529698202), for: .disabled)
            hintButton.setTitleColor(#colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), for: .normal)
        }
    }
    
    private func addTapRecognizer(for cardView: CardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(recognizedBy:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        cardView.addGestureRecognizer(tap)
    }
    
    @objc private func tapCard(recognizedBy recognizer: UITapGestureRecognizer){
        switch recognizer.state {
            case .ended:
                if let cardView = recognizer.view! as? CardView {
                    hintButton.isEnabled = false
                    game.choosenCard(index: boardView.cardViews.index(of: cardView)!)
                    game.matchingResult()
                    if game.bonusTime {
                        timeBonusAnimation()
                    }
                    if game.matchDetector != nil && !game.matchDetector! {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            self.deleteCardsFromView()
                            self.hintButton.isEnabled = true
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
                timerLabel.isHidden = false
            }
    }
    
    @objc func runTimer() {
        game.secondCounter += 0.1
        game.bonusCounter += 0.1
        
        let flooredCounter = Int(floor(game.secondCounter))
        
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
        var newCardViews = [CardView] ()
        if boardView.cardViews.count - game.cardsOnTable.count > 0 {
            boardView.removeCardsView(cardsViewForRemove: matchedCardsSet)
        }
        let numberCardView = boardView.cardViews.count
        
        for index in game.cardsOnTable.indices {
            let card = game.cardsOnTable[index]
            if index > (numberCardView - 1) {
                let cardView = CardView()
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
            score.text = "Score: \(game.score)"
        }
        
//        if !game.endGameDetector && game.selectedCards.count == 2 {
        if game.endGameDetector {
            print(game.score)
            endGameViewAdding()
        }
    }
    
    private func blurController() {
        if pauseView != nil {
            if view.subviews.contains(pauseView!) {
                view.addSubview(blurEffectView)
                view.bringSubviewToFront(pauseView!)
                timer.invalidate()
                timerIsRunnning = false
            } else {
                blurEffectView.removeFromSuperview()
                pauseView = nil
                startTimer()
            }
        }
    }
    
    weak var backToMenuButton: UIButton? {
        didSet {
            backToMenuButton?.addTarget(self, action: #selector(presentMainMenuController), for: .touchUpInside)
        }
    }
    weak var restartGameButton: UIButton? {
        didSet {
            restartGameButton?.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        }
    }
    
    @objc func presentMainMenuController(){
        
        let mainMenuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenuController")
        mainMenuVC.modalPresentationStyle = .fullScreen
        mainMenuVC.modalTransitionStyle = .crossDissolve
        self.present(mainMenuVC, animated: true, completion: nil )
    }
    
    @objc func restartGame(){
        if endGameView != nil {
            endGameView?.removeFromSuperview()
            endGameView = nil
            timerLabel.alpha = 1
            score.alpha = 1
        }
        if pauseView != nil {
            pauseView?.removeFromSuperview()
            blurController()

        }
        boardView.resetAllCards()
        game = GameModel()
        dealCardsAnimation()
        updateViewFromModel()

    }
  
    private func pauseViewAdding() {
        if pauseView == nil {
            pauseView = PauseView(frame: inScreenViewRect!)
            backToMenuButton = pauseView!.backToMenuAnswerView?.accept
            restartGameButton = pauseView!.restartAnswerView?.accept
            view.addSubview(pauseView!)
        } else {
            view.addSubview(pauseView!)
        }
    }
    
    private func endGameViewAdding() {
        timer.invalidate()
        var currentCardsForDelete = 0
        let dealInterval = 0.03 * Double(boardView.gridRows + 1)
        Timer.scheduledTimer(withTimeInterval: dealInterval, repeats: false) { timer in
            self.cardsForDelete.forEach { cardView in
                cardView.endGameCardsAnimation(delay: TimeInterval(currentCardsForDelete) * 0.25)
                currentCardsForDelete += 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            if self.endGameView == nil {
                self.endGameView = EndGameView(frame: self.inScreenViewRect!)
                self.endGameView?.score = self.game.score
                self.endGameView?.time = self.timerLabel.text!
                self.restartGameButton = self.endGameView!.restart
                self.backToMenuButton = self.endGameView!.backToMenu
                self.timerIsRunnning = false
                self.view.addSubview(self.endGameView!)
            }
            UIView.animate(withDuration: 0.3,
                           animations: { self.score.alpha = 0
                                         self.timerLabel.alpha = 0 })
            self.hintButton.isEnabled = false
        })
        
        
    }

    private func addParallaxToView(view: UIImageView) {
        
        let screenSize = view.bounds.size
        view.bounds.size = CGSize(width: screenSize.width * 1.2, height: screenSize.height * 1.2)
        backgroundView.frame.size = view.bounds.size
        print( backgroundView.frame.size )
        
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
    
    private func updateCardView(_ cardView: CardView, for card: Card) {
        
        cardView.symbolType = card.shape.rawValue
        cardView.fillType = card.fill.rawValue
        cardView.colorType = card.color.rawValue
        cardView.count = card.count.rawValue
        cardView.isSelected = game.selectedCards.contains(card)
        cardView.isFaceUp = card.isFaceUp

        if let matchDetector = game.matchDetector {
            if game.cardForMatching.contains(card) {
                cardView.isMatched = matchDetector
            }
        } else {
            cardView.isMatched = nil
        }
    }
    
    private func minimizeAndDeleteAnimation() {
 
        var cardsForScale: [CardView] {
            var cardsForScale = [CardView]()
            var tmpCard = CardView()
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
                if self.game.gameIsResume {
                    cardView.dealCardsFromDeckWithouAnimation(from: dealPoint)
                    self.startTimer()
                    
                } else {
                    cardView.dealCardsFromDeckAnimation(from: dealPoint,delay: TimeInterval(currentCardsForDeal) * 0.25)
                }
                currentCardsForDeal += 1
            }
        }
        Timer.scheduledTimer(withTimeInterval: Double(self.cardsForDeal.count) * 0.35, repeats: false) {_ in
            self.hintButton.isEnabled = true
            self.startTimer()
            self.game.bonusCounter = 0.0
            self.dealCompleted = false
            self.game.gameIsResume = false
        }
    }
    
    @objc func backgroundPauseView() {
        if pauseView == nil {
            pauseViewAdding()
            gameModelJSON = game
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




