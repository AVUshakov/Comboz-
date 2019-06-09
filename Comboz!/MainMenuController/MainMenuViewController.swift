//
//  MainMenuViewController.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 09/12/2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    struct LocalizedText {
        static let newGameButton  = NSLocalizedString("NEW GAME", comment: "newGameButton")
        static let resumeButton   = NSLocalizedString("RESUME", comment: "resumeButton")
    }
    
    var animator: UIDynamicAnimator!
        
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var animatedView: AnimatedView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    var settingsView: SettingsView!
    
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var settingsButton: UIButton! {
        didSet {
            settingsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    var resumeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "On_button"), for: .normal)
        button.addTarget(self, action: #selector(pushButtonMenuAnimation), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    var newGameButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "Play_button"), for: .normal)
        button.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        mainMenuLogo.center = CGPoint(x: view.bounds.midX, y: view.bounds.minY)
        blurEffectView.frame = view.bounds
//        animatedView.addView()
//        animatedView.animationBackground()
    }
    
    override func viewDidLayoutSubviews() {
        if settingsView?.helpView?.window == nil && settingsView != nil {
            settingsView!.helpView = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        
        setHiddenButtons()
        startVCMenuAnimation()
        animator = UIDynamicAnimator(referenceView: view)
        if !UserDefaults.standard.bool(forKey: "music") {
        AudioController.sharedController.playBackgroundMusic(file: AudioController.SoundFile.tapIn.rawValue)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mainMenuLogo.center = CGPoint(x: view.bounds.midX, y: view.bounds.minY)
    }
    
    override func viewWillLayoutSubviews() {
        if settingsView?.window == nil  {
            settingsView = nil
            blurEffectView.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if settingsView != nil && settingsView?.helpView == nil{
                if touch.view != settingsView {
                    settingsView.animatedRemove()
                }
            }
        }
    }
    
    @IBOutlet weak var mainMenuLogo: UIImageView!
    
    @IBOutlet weak var stackMenuButtons: UIStackView!
    
    @IBOutlet weak var bestTimeLabel: UILabel! {
        didSet {
            if let timerArray = UserDefaults.standard.object(forKey: "TimeRecord") as? [Int] {
                
                var minuteString = "\(timerArray[1])"
                if timerArray[1] < 10 {
                    minuteString = "0\(timerArray[1])"
                }
                
                var secondString = "\(timerArray[2])"
                if timerArray[2] < 10 {
                    secondString = "0\(timerArray[2])"
                }
                bestTimeLabel.text = "\(timerArray[0]):\(minuteString):\(secondString)"
            }
        }
    }
    
    @IBOutlet weak var hiscoreLabel: UILabel! {
        didSet {
            if let hiScore = UserDefaults.standard.object(forKey: "HiScore") {
                hiscoreLabel.text = "\(hiScore)"
            }
        }
    }
    
    @IBOutlet weak var loadingBar: UIProgressView! {
        didSet {
            loadingBar.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            loadingBar.layer.borderWidth = 2
            loadingBar.layer.cornerRadius = 10
        }
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        
        if UserDefaults.standard.object(forKey: "SavedGameModel") != nil {
            hideButtonAnimation()
        } else {
            UserDefaults.standard.removeObject(forKey: "SavedGameModel")
            UserDefaults.standard.removeObject(forKey: "SavedTimer")
            pushButtonMenuAnimation()
        }
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        settingsViewAdding()
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)

    }
    
    private func setHiddenButtons() {
        newGameButton.setAttributedTitle(TextFont.AttributeText(_size: view.bounds.width * 0.8, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizedText.newGameButton), for: .normal)
        resumeButton.setAttributedTitle(TextFont.AttributeText(_size: view.bounds.width * 0.8, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizedText.resumeButton), for: .normal)
        stackMenuButtons.addArrangedSubview(resumeButton)
        stackMenuButtons.addArrangedSubview(newGameButton)
        resumeButton.alpha = 0
        newGameButton.alpha = 0
        resumeButton.isHidden = true
        newGameButton.isHidden = true
    }
    
    @objc func startNewGame() {
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
        UserDefaults.standard.removeObject(forKey: "SavedGameModel")
        UserDefaults.standard.removeObject(forKey: "SavedTimer")
        pushButtonMenuAnimation()
    }
    
    private func hideButtonAnimation () {
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.playButton.alpha = 0
                        self.settingsButton.alpha = 0
                        },
                       completion:
            { finished in
                self.playButton.isHidden = true
                self.settingsButton.isHidden = true
                self.resumeButton.isHidden = false
                self.newGameButton.isHidden = false
                UIView.animate(withDuration: 0.3,
                               animations: {
                                self.resumeButton.alpha = 1
                                self.newGameButton.alpha = 1
                })
            })
    }
    
    private func startVCMenuAnimation() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1,
                                                       delay: 0,
                                                       options:.curveEaseInOut,
                                                       animations: {
                                                        self.mainMenuLogo.center = self.view.center },
                                                       completion: nil)
    }
    
    @objc func pushButtonMenuAnimation() {
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
        let pointForStackButtonHidding = CGPoint(x: view.bounds.midX, y: view.bounds.maxY - view.bounds.height * 0.2)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3,
                                                       delay: 0,
                                                       options:.curveEaseInOut,
                                                       animations: {
                                                        self.stackMenuButtons.center = pointForStackButtonHidding
                                                        self.stackMenuButtons.alpha = 0
                                                        self.topView.alpha = 0
                                                        },
                                                       completion: nil)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                       delay: 0,
                                                       options:.curveEaseInOut,
                                                       animations: {
                                                        self.mainMenuLogo.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY - self.view.bounds.height * 0.1)
                        self.mainMenuLogo.transform = CGAffineTransform.identity.scaledBy(x: 1.05, y: 1.05)
                self.loadingBar.center = CGPoint(x: self.mainMenuLogo.center.x, y: self.mainMenuLogo.bounds.maxY + self.view.bounds.height * 0.2)
                self.loadingBar.alpha = 0.9
        },
                                                       completion: { finished in
                Timer.scheduledTimer(timeInterval: 0.003,
                                     target: self,
                                     selector: #selector(MainMenuViewController.updateLoadingBar),
                                     userInfo: nil,
                                     repeats: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(1.2)), execute: {
                    self.mainMenuLogo.alpha = 0
                    self.loadingBar.alpha = 0
                    self.topView.alpha = 0
                    self.hiscoreLabel.alpha = 0
                    self.transitionViews()
                        })
                    }
                )
            }
    
    @objc func updateLoadingBar() {
        if loadingBar.progress != 1 {
            loadingBar.progress += 0.005
        }
    }
    
    private func transitionViews() {
        let gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.modalTransitionStyle = .crossDissolve
        self.present(gameVC, animated: true, completion: nil)
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
    
    private func settingsViewAdding() {
        if settingsView == nil {
            settingsView = SettingsView(frame: view.frame)
            if settingsView != nil {
                view.addSubview(settingsView!)
                view.addSubview(blurEffectView)
                view.bringSubviewToFront(settingsView!)
                settingsView?.animatedAdd()
            }
        } else {
            blurEffectView.removeFromSuperview()
            settingsView?.animatedRemove()
            settingsView = nil
        }
    }
    
    private func soundFXPlay(sound: String) {
        if !UserDefaults.standard.bool(forKey: "soundFX") {
            AudioController.sharedController.playFXSound(file: sound)
        }
    }
}

struct ImageLabels {
    static let label1: CGFloat = 0.625
    static let spacingDx: CGFloat = 4.0
    static let spacingDy: CGFloat = 4.0
}


