//
//  ViewController.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 15.04.2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class ViewController: UIViewController, GADInterstitialDelegate {
    
    var game = GameModel()
    
    var pauseView: PauseView?
    
    var endGameView: EndGameView?
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    var gameModelJSON: GameModel? {
        get {
            if  let savedGameModel = UserDefaults.standard.object(forKey: "SavedGameModel") as? Data {
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
                    UserDefaults.standard.set(json, forKey: "SavedGameModel")
                }
            }
        }
    }
    
    
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var score: UILabel! {
        didSet {
            score.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBAction func pauseButton(_ sender: UIButton) {
        showGADModView()
        pauseViewAdding()
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    @IBOutlet weak var timeBonusLabel: UILabel!
    
    @IBOutlet weak var pauseButton: UIButton! 
    
    private func timeBonusAnimation() {
        let point = timeBonusLabel.center
        timeBonusLabel.center = CGPoint(x: view.center.x, y: view.frame.minY - score.frame.height)
        timeBonusLabel.isHidden = false
        timeBonusLabel.blinkEffect(_duration: 0.2)
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
        if  endGameView == nil {
            gameModelJSON = game
        } else {
            UserDefaults.standard.removeObject(forKey: "SavedGameModel")
//            print("saved")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let gameFROM = gameModelJSON {
            game = gameFROM
            updateViewFromModel()
        }
        blurEffectView.frame = view.bounds
        if endGameView != nil {
            endGameView?.newRecordLable.blinkEffect(_duration: 0.5)
        }
        let currentLang = LocalizationSystem.instance.getLanguage()
        LocalizationSystem.instance.setLanguage(languageCode: currentLang)
        setOutletButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name("returnFromBackground"), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        blurController()
        scoreLableUpdate()
    }
    
    
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioController.sharedController.viewController = "GameScreen"
        updateViewFromModel()
        let purchased = UserDefaults.standard.bool(forKey: "Purchase")
        if purchased == false {
            interstitial = createAndLoadInterstitial()
        }
    
        NotificationCenter.default.addObserver(self, selector: #selector(backgroundPauseView), name: NSNotification.Name("goToBackground"), object: nil)
        if !UserDefaults.standard.bool(forKey: "music") {
            AudioController.sharedController.playBackgroundMusic(file: AudioController.SoundFile.menuMusic.rawValue)
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func  interstitialDidDismissScreen (_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    func showGADModView() {
        if interstitial != nil {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad not ready")
            }
        }
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
                soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
                if let cardView = recognizer.view! as? CardView {
                    hintButton.isEnabled = false
                    deal3CardsButton.isEnabled = false
                    game.choosenCard(index: boardView.cardViews.firstIndex(of: cardView)!)
                    game.matchingResult()
                    if game.bonusTime {
                        timeBonusAnimation()
                    }
                    if game.matchDetector != nil && !game.matchDetector! {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            self.deleteCardsFromView()
                            self.hintButton.isEnabled = true
                            self.deal3CardsButton.isEnabled = true
                        })
                    }
                }
            default:
                break
        }
        updateViewFromModel()
    }
    
    @objc func willEnterForeground() {
        print("oh no anim stops")
    }
    
    @IBAction func showHint() {
        game.showHintCard()
        if game.hintCards.isEmpty {
            deal3CardsButton.isEnabled = true
        } else {
            deal3CardsButton.isEnabled = false
        }
        if game.hintCards.isEmpty && !dealCompleted {
            hintButton.isEnabled = false
        }
        game.matchingResult()
        updateViewFromModel()
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    @IBAction func deal3cards(_ sender: UIButton) {
        game.takeCardsFromDeck()
        dealCompleted = true
        deal3CardsButton.isEnabled = false
        hintButton.isEnabled = false
        updateViewFromModel()
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var timerArray = [Int]()
    var timeRecord = String()
    
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
        
        timerArray.insert(hour, at: 0)
        timerArray.insert(minute, at: 1)
        timerArray.insert(second, at: 2)
    }
    
    private func deleteCardsFromView() {
        game.removeCards()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        updateCardsViewFromModel()
    }
    
    private func updateCardsViewFromModel() {
        var newCardViews = [CardView]()
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
        }
        
//        if !game.endGameDetector && game.selectedCards.count == 2 {
//            game.score = UserDefaults.standard.integer(forKey: "HiScore") + 1
        
        if game.endGameDetector {
            endGameViewAdding()
        }
        
        guard game.matchDetector == nil else {
            if game.matchDetector! {
                typeFeedback(type: .success)
                deal3CardsButton.isEnabled = false
            } else {
                typeFeedback(type: .error)
            }
            return
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
    
    @objc func presentMainMenuController() {
        let mainMenuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenuController")
        mainMenuVC.modalPresentationStyle = .fullScreen
        mainMenuVC.modalTransitionStyle = .crossDissolve
        self.present(mainMenuVC, animated: true, completion: nil )
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    @objc func restartGame(){
        if endGameView != nil {
            endGameView?.animatedRemove()
            endGameView = nil
            timerLabel.alpha = 1
            score.alpha = 1
            hintButton.alpha = 1
            deal3CardsButton.alpha = 1
            pauseButton.alpha = 1
        }
        if pauseView != nil {
            pauseView?.animatedRemove()
            blurController()
        }
        boardView.resetAllCards()
        game = GameModel()
        dealCardsAnimation()
        updateViewFromModel()
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
  
    private func pauseViewAdding() {
        if pauseView == nil {
            pauseView = PauseView(frame: view.frame)
            backToMenuButton = pauseView!.backToMenuAnswerView?.accept
            restartGameButton = pauseView!.restartAnswerView?.accept
            view.addSubview(pauseView!)
            pauseView?.animatedAdd()
        } else {
            view.addSubview(pauseView!)
        }
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    private func endGameViewAdding() {
        
        var currentCardsForDelete = 0
        let dealInterval = 0.03 * Double(boardView.gridRows + 1)
        
        timer.invalidate()
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.score.alpha = 0
                        self.timerLabel.alpha = 0
                        self.hintButton.alpha = 0
                        self.deal3CardsButton.alpha = 0
                        self.pauseButton.alpha = 0
        })
 
        Timer.scheduledTimer(withTimeInterval: dealInterval, repeats: false) { timer in
            self.cardsForDelete.forEach { cardView in
                cardView.endGameCardsAnimation(delay: TimeInterval(currentCardsForDelete) * 0.25)
                currentCardsForDelete += 1
            }
        }
        if UserDefaults.standard.object(forKey: "HiScore") != nil {
            let hiScore = UserDefaults.standard.integer(forKey: "HiScore")
            if game.score > hiScore {
                UserDefaults.standard.set(game.score, forKey: "HiScore")
            }
        } else {
            UserDefaults.standard.set(game.score, forKey: "HiScore")
        }
        
        if UserDefaults.standard.object(forKey: "TimeRecord") != nil {
            let timerRecord = UserDefaults.standard.object(forKey: "TimeRecord") as! [Int]
            if timerRecordChecker(arrayFaster: timerArray , arraySlower: timerRecord) {
                UserDefaults.standard.set(timerArray, forKey: "TimeRecord")
            }
        } else {
                UserDefaults.standard.set(timerArray, forKey: "TimeRecord")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            if self.endGameView == nil {
                self.endGameView = EndGameView(frame: self.view.frame)
                self.endGameView!.labelsSet(_score: self.game.score, _time: self.timerLabel.text!)
                self.restartGameButton = self.endGameView!.restart
                self.backToMenuButton = self.endGameView!.backToMenu
                self.timerIsRunnning = false
                self.view.addSubview(self.endGameView!)
                self.endGameView?.animatedAdd()
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.showGADModView()
        })
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
                animations: {
                    self.boardView.isUserInteractionEnabled = false
                    cardView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
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
        self.boardView.isUserInteractionEnabled = false

        let dealInterval = 0.03 * Double(boardView.gridRows + 1)
        Timer.scheduledTimer(withTimeInterval: dealInterval, repeats: false) {
            timer in
            self.cardsForDeal.forEach { cardView in
                let dealPoint = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.maxY + cardView.bounds.height)

                cardView.dealCardsFromDeckAnimation(from: dealPoint,delay: TimeInterval(currentCardsForDeal) * 0.25)
                currentCardsForDeal += 1
            }
        }
            
        Timer.scheduledTimer(withTimeInterval: Double(self.cardsForDeal.count) * 0.35, repeats: false) {_ in
            self.hintButton.isEnabled = true
            self.boardView.isUserInteractionEnabled = true
            if !(self.game.cardsOnTable.count > 20) {
                self.deal3CardsButton.isEnabled = true
            }
            self.startTimer()
            self.game.bonusCounter = 0.0
            self.dealCompleted = false
        }
    }
    
    @objc func backgroundPauseView() {
        if pauseView == nil && endGameView == nil {
            pauseViewAdding()
            gameModelJSON = game
        }
    }
    
    private func timerRecordChecker(arrayFaster: [Int], arraySlower: [Int]) -> Bool  {
        var returnBool = false
        if arrayFaster[0] <= arraySlower [0] {
            if arrayFaster[1] <= arraySlower [1] {
                if arrayFaster[2] < arraySlower [2] {
                    returnBool = true
                }
            }
        } else {
            returnBool = false
        }
        return returnBool
    }
    
    private func scoreLableUpdate() {
        let index = score.text!.firstIndex(of: ":")!
        let tmpScore = score.text![...index]
        score.text = "\(tmpScore) \(game.score)"
    }
    
    private func soundFXPlay(sound: String) {
        if !UserDefaults.standard.bool(forKey: "soundFX") {
            AudioController.sharedController.playFXSound(file: sound)
        }
    }
    
    private func typeFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let tapticGenerator = UINotificationFeedbackGenerator()
        let savedSwitcher = UserDefaults.standard.bool(forKey: "vibration")
        guard savedSwitcher else { tapticGenerator.notificationOccurred(type)
            return
        }
    }
    
    private func setOutletButtons() {
        score.text = LocalizationSystem.instance.localizedStringForKey(key: "SCORE: 0", comment: "")
        pauseButton.setTitle(LocalizationSystem.instance.localizedStringForKey(key: "PAUSE", comment: ""), for: .normal)
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

extension UIView {
    
    func animatedAdd() {
        self.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        self.alpha = 0.3
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { self.transform = CGAffineTransform.identity.scaledBy(x: 1.04, y: 1.04)
                                     self.alpha = 1},
                       completion: { _ in
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)},
                       completion: nil)
        })
    }
    
    func animatedRemove() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { self.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                     self.alpha = 0},
                       completion: { _ in self.removeFromSuperview()})
    }
    
    func blinkEffect(_duration: TimeInterval) {
        UIView.transition(with: self,
                          duration: _duration,
                          options: [.transitionCrossDissolve, .repeat],
                          animations: { [weak self] in self?.alpha = 1 },
                          completion: nil )
    }
}




