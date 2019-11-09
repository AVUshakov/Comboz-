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
        
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var animatedView: AnimatedView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView! = {
        var backroundImage = UIImageView()
        var image = String()
        if UIDevice().userInterfaceIdiom == .phone
        {
            switch UIScreen.main.bounds.height {
            case 812: //iphoneX
                image = "background_iphoneX"
            case 896: //iphone11
                image = "background_iphonePlus"
            case 736: //iphonePlus
                image = "background_iphonePlus"
            default:
                image = "background_iphone"
            }
        } else if UIDevice().userInterfaceIdiom == .pad {
            image = "background_ipad"
        }
        if var background = UIImage(named: image) {
            backroundImage = UIImageView(image: background)
        }
        return backroundImage
    }()
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    var settingsView: SettingsView!
    var purchaseView: PurchaseView!
    var languageMenuView: LanguageMenuView!
    
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
    @IBOutlet var changeLanguageButton: UIButton!
    
    @IBAction func changeLanguage() {
        languageMenuAdding()
    }
    
    @IBAction func removeAdButton(_ sender: Any) {
        purchaseViewAdding()
    }
    
    @IBOutlet weak var removeAdButton: UIButton!
    
    var resumeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "def_button"), for: .normal)
        button.addTarget(self, action: #selector(pushButtonMenuAnimation), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    var newGameButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "def_button"), for: .normal)
        button.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        mainMenuLogo.center = CGPoint(x: view.bounds.midX, y: view.bounds.minY)
        blurEffectView.frame = view.bounds
        animatedView.setBackgrounds()
        animatedView.animateBackground()
        let currentLang = LocalizationSystem.instance.getLanguage()
        LocalizationSystem.instance.setLanguage(languageCode: currentLang)
        setOutletButtons()
        setHiddenButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name("returnFromBackground"), object: nil)
    }
    
    @objc func willEnterForeground() {
        animatedView.animateBackground()
    }
    
    override func viewDidLayoutSubviews() {
        if settingsView?.helpView?.window == nil && settingsView != nil {
            settingsView!.helpView = nil
        }
        let purchaseSave = UserDefaults.standard.bool(forKey: "Purchase")
        if purchaseSave {
            removeAdButton.alpha = 0
        } else {
            removeAdButton.alpha = 1
        }
    }
    
    @objc func updateView(){
        setOutletButtons()
        setHiddenButtons()
        if languageMenuView != nil {
            languageMenuView.removeFromSuperview()
            languageMenuView = nil
            languageMenuAdding()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startVCMenuAnimation()
        animator = UIDynamicAnimator(referenceView: view)
        AudioController.sharedController.viewController = "MainMenu"
        if !UserDefaults.standard.bool(forKey: "music") {
        AudioController.sharedController.playBackgroundMusic(file: AudioController.SoundFile.menuMusic.rawValue)
        }
        print(resumeButton.bounds.width)
        print(stackMenuButtons.bounds.width)
        print(removeAdButton.bounds.width)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mainMenuLogo.center = CGPoint(x: view.bounds.midX, y: view.bounds.minY)
    }
    
    override func viewWillLayoutSubviews() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: NSNotification.Name("languge_changed"), object: nil)
        
        if settingsView?.window == nil  {
            settingsView = nil
        }
        
        if purchaseView?.window == nil  {
            purchaseView = nil
        }
        
        if languageMenuView?.window == nil  {
            languageMenuView = nil
        }
        
        if purchaseView?.window == nil && settingsView?.window == nil && languageMenuView?.window == nil {
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
    
    @IBOutlet weak var hiScoreLabel: UILabel! {
        didSet  {
                    if let hiScore = UserDefaults.standard.object(forKey: "HiScore") {
                           hiScoreLabel.text = "\(hiScore)"
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
        let edgeInset = UIEdgeInsets(top: 6, left: 10, bottom: 10, right: 10)
        newGameButton.setAttributedTitle(TextFont.AttributeText(_size: view.bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "NEW GAME", comment: ""), shadows: true), for: .normal)
        
        newGameButton.contentEdgeInsets = edgeInset
        resumeButton.setAttributedTitle(TextFont.AttributeText(_size: view.bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "RESUME", comment: ""), shadows: true), for: .normal)
        resumeButton.contentEdgeInsets = edgeInset
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
        if !UserDefaults.standard.bool(forKey: "music") {
            AudioController.sharedController.backgroundMusic.setVolume(0, fadeDuration: 1)
        }
    }
    
    private func hideButtonAnimation () {
    
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.playButton.alpha = 0
                        self.settingsButton.alpha = 0
                        self.topView.alpha = 0
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
        stackMenuButtons.widthAnchor.constraint(equalToConstant: removeAdButton.bounds.width).isActive = true
        resumeButton.widthAnchor.constraint(equalToConstant: stackMenuButtons.bounds.width).isActive = true
        newGameButton.widthAnchor.constraint(equalToConstant: stackMenuButtons.bounds.width).isActive = true
        print(resumeButton.bounds.width)
        print(stackMenuButtons.bounds.width)
        print(removeAdButton.bounds.width)
    }
    
    private func startVCMenuAnimation() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1,
                                                       delay: 0,
                                                       options:.curveEaseInOut,
                                                       animations: {
                                                        self.mainMenuLogo.center = self.view.center
        },
                                                       completion: nil)
    }
    
    @objc func pushButtonMenuAnimation() {
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
        let pointForStackButtonHidding = CGPoint(x: view.bounds.midX, y: view.bounds.maxY - view.bounds.height * 0.2)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3,
                                                       delay: 0,
                                                       options:.curveEaseInOut,
                                                       animations: {
                                                        self.removeAdButton.isHidden = true

                                                        self.bottomView.center = pointForStackButtonHidding
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
//                    self.hiscoreLabel.alpha = 0
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
    
    private func languageMenuAdding() {
        if languageMenuView == nil {
            languageMenuView = LanguageMenuView(frame: view.frame)
                   if languageMenuView != nil {
                       view.addSubview(languageMenuView!)
                       view.addSubview(blurEffectView)
                       view.bringSubviewToFront(languageMenuView!)
                       languageMenuView?.animatedAdd()
                   }
               } else {
                   blurEffectView.removeFromSuperview()
                   languageMenuView?.animatedRemove()
                   languageMenuView = nil
               }
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
    
    private func purchaseViewAdding() {
        if purchaseView == nil {
            purchaseView = PurchaseView(frame: view.frame)
            if purchaseView != nil {
                view.addSubview(purchaseView!)
                view.addSubview(blurEffectView)
                view.bringSubviewToFront(purchaseView!)
                purchaseView?.animatedAdd()
            }
        } else {
            blurEffectView.removeFromSuperview()
            purchaseView?.animatedRemove()
            purchaseView = nil
        }
    }
    
    private func soundFXPlay(sound: String) {
        if !UserDefaults.standard.bool(forKey: "soundFX") {
            AudioController.sharedController.playFXSound(file: sound)
        }
    }
    
    private func setOutletButtons() {
        playButton.setTitle(LocalizationSystem.instance.localizedStringForKey(key: "PLAY!", comment: ""), for: .normal)
        settingsButton.setTitle(LocalizationSystem.instance.localizedStringForKey(key: "SETTINGS", comment: ""), for: .normal)
        removeAdButton.setTitle(LocalizationSystem.instance.localizedStringForKey(key: "REMOVE AD", comment: ""), for: .normal)
        let currentLang = LocalizationSystem.instance.getLanguage()
        switch currentLang {
        case "en":
            changeLanguageButton.setBackgroundImage(UIImage(named: "eng_btn"), for: .normal)
        case "fr":
            changeLanguageButton.setBackgroundImage(UIImage(named: "fra_btn"), for: .normal)
        case "es":
            changeLanguageButton.setBackgroundImage(UIImage(named: "esp_btn"), for: .normal)
        case "ru":
            changeLanguageButton.setBackgroundImage(UIImage(named: "rus_btn"), for: .normal)
        case "zh":
            changeLanguageButton.setBackgroundImage(UIImage(named: "chn_btn"), for: .normal)
        default:
            break
        }
    }
}

struct ImageLabels {
    static let label1: CGFloat = 0.625
    static let spacingDx: CGFloat = 4.0
    static let spacingDy: CGFloat = 4.0
}


