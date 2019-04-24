//
//  MainMenuViewController.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 09/12/2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    var animator: UIDynamicAnimator!
    
    var snap: UISnapBehavior!
    
    var inScreenViewRect: CGRect?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var settingsView: SettingsView!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    var resumeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "resume_button"), for: .normal)
        button.addTarget(self, action: #selector(pushButtonMenuAnimation), for: .touchUpInside)
        return button
    }()
    var newGameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "newgame_button"), for: .normal)
        button.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        mainMenuLogo.center = CGPoint(x: view.bounds.midX, y: view.bounds.minY)
    }

    override func viewDidAppear(_ animated: Bool) {
        if view.window != nil {
            inScreenViewRect = CGRect(x: (view.frame.width - view.frame.width * 0.8) / 2,
                                      y: (view.frame.height - view.frame.height * 0.8) / 2,
                                      width: view.frame.width * 0.8,
                                      height: view.frame.height * 0.8)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if settingsView?.window == nil {
            settingsView = nil
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
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
        settingsViewAdding()
//        stackMenuButtons.animatedRemove()
    }
    
    private func setHiddenButtons() {
        stackMenuButtons.addArrangedSubview(resumeButton)
        stackMenuButtons.addArrangedSubview(newGameButton)
        resumeButton.imageView?.contentMode = .scaleAspectFill
        newGameButton.imageView?.contentMode = .scaleAspectFill
        resumeButton.heightAnchor.constraint(equalToConstant: 88).isActive = true
        newGameButton.heightAnchor.constraint(equalToConstant: 88).isActive = true
        resumeButton.imageView?.contentMode = .scaleAspectFit
        newGameButton.imageView?.contentMode = .scaleAspectFit
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
        let pointForStackButtonHidding = CGPoint(x: view.bounds.midX, y: view.bounds.maxY)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3,
                                                       delay: 0,
                                                       options:.curveEaseInOut,
                                                       animations: {
                                                        self.stackMenuButtons.center = pointForStackButtonHidding
                                                        self.stackMenuButtons.alpha = 0
                                                        },
                                                       completion: nil)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                       delay: 0,
                                                       options:.curveEaseInOut,
                                                       animations: {
                        self.mainMenuLogo.center = self.view.center
                        self.mainMenuLogo.transform = CGAffineTransform.identity.scaledBy(x: 1.05, y: 1.05)
                self.loadingBar.center = CGPoint(x: self.mainMenuLogo.center.x, y: self.mainMenuLogo.bounds.maxY + 200)
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
                    self.backgroundImage.alpha = 0
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
            settingsView = SettingsView(frame: inScreenViewRect!)
            if settingsView != nil {
                view.addSubview(settingsView!)
                settingsView?.animatedAdd()
            }
        } else {
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


