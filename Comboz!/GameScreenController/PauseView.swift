//
//  PauseView.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 17/01/2019.
//  Copyright © 2019 Alexander Ushakov. All rights reserved.
//

import UIKit

class PauseView: UIView {
    
    var pauseTextLabel = UILabel()
    
    var settings = UIButton()
    var backToMenu = UIButton()
    var restart = UIButton()
    var resumeGameButton = UIButton()
    
    var stackButtonsView = UIStackView()
    
    var settingsView: SettingsView?
    
    var animator: UIDynamicAnimator!
    var snap: UISnapBehavior!

    var backgroundImage = UIImageView() {
        didSet {
            if settingsView != nil {
                backgroundImage.alpha = 0
            } else {
                backgroundImage.alpha = 1
            }
        }
    }
    
    var restartAnswerView: AnswerView?
    var backToMenuAnswerView: AnswerView?
    
    let scaleRatio : CGFloat = 0.12
    let edgeInset = UIEdgeInsets(top: 6, left: 10, bottom: 10, right: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if settingsView?.window == nil {
            settingsView = nil
        }
    }
    
    private func viewSetup() {
        var image = String()
        if UIDevice().userInterfaceIdiom == .phone
        {
            switch UIScreen.main.bounds.height {
            case 812: //iphoneX
                image = "menu_frame_iphoneX"
            case 896: //iphoneXS
                image = "menu_frame_iphoneX"
            default:
                image = "menu_frame_iphoneX"
            }
        } else if UIDevice().userInterfaceIdiom == .pad {
            image = "menu_frame_ipad"
        }
 
        backgroundImage.frame.size = CGSize(width: frame.width * 0.8, height: frame.height * 0.6)
        backgroundImage.center = center
        backgroundImage.image = UIImage(named: image)
        addSubview(backgroundImage)
        
        stackButtonsView.frame = backgroundImage.frame
        stackButtonsView.translatesAutoresizingMaskIntoConstraints = false
        stackButtonsView.spacing = 10
        stackButtonsView.axis = .vertical
        stackButtonsView.center = center
        addSubview(stackButtonsView)
        
        pauseTextLabel.attributedText = TextFont.AttributeText(_size: bounds.width * 1.3, color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "PAUSE", comment: ""), shadows: true)
        pauseTextLabel.translatesAutoresizingMaskIntoConstraints = false
        pauseTextLabel.textAlignment = .center
        
        restart.setBackgroundImage(UIImage(named: "def_button"), for: .normal)
        settings.setBackgroundImage(UIImage(named: "def_button"), for: .normal)
        resumeGameButton.setBackgroundImage(UIImage(named: "def_button"), for: .normal)
        backToMenu.setBackgroundImage(UIImage(named: "back_button"), for: .normal)
        
        restart.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "RESTART", comment: ""), shadows: true), for: .normal)
        settings.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "SETTINGS", comment: ""), shadows: true), for: .normal)
        resumeGameButton.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "RESUME", comment: ""), shadows: true), for: .normal)
        backToMenu.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "MAIN MENU", comment: ""), shadows: true), for: .normal)

        restart.translatesAutoresizingMaskIntoConstraints = false
        settings.translatesAutoresizingMaskIntoConstraints = false
        resumeGameButton.translatesAutoresizingMaskIntoConstraints = false
        backToMenu.translatesAutoresizingMaskIntoConstraints = false
        
        restart.titleLabel?.adjustsFontSizeToFitWidth = true
        settings.titleLabel?.adjustsFontSizeToFitWidth = true
        resumeGameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        backToMenu.titleLabel?.adjustsFontSizeToFitWidth = true
        
        restart.contentEdgeInsets = edgeInset
        settings.contentEdgeInsets = edgeInset
        resumeGameButton.contentEdgeInsets = edgeInset
        backToMenu.contentEdgeInsets = edgeInset

        restart.addTarget(self, action: #selector(openAnswerView), for: .touchUpInside)
        settings.addTarget(self, action: #selector(settingsViewAdding), for: .touchUpInside)
        resumeGameButton.addTarget(self, action: #selector(closePauseView), for: .touchUpInside)
        backToMenu.addTarget(self, action: #selector(openAnswerView), for: .touchUpInside)
        
        stackButtonsView.addArrangedSubview(pauseTextLabel)
        stackButtonsView.addArrangedSubview(resumeGameButton)
        stackButtonsView.addArrangedSubview(restart)
        stackButtonsView.addArrangedSubview(settings)
        stackButtonsView.addArrangedSubview(backToMenu)
        
        restartAnswerView = AnswerView(frame: self.bounds)
        backToMenuAnswerView = AnswerView(frame: self.bounds)
        
        constraintsParameters()
    }
    
    @objc func closePauseView() {
        self.animatedRemove()
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    @objc func settingsViewAdding() {
        if settingsView == nil {
            settingsView = SettingsView(frame: self.bounds)
            if settingsView != nil {
                addSubview(settingsView!)
                settingsView?.animatedAdd()
            }
        } else {
            settingsView!.animatedRemove()
            settingsView = nil
        }
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    private func constraintsParameters() {
        
        stackButtonsView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackButtonsView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        pauseTextLabel.heightAnchor.constraint(equalToConstant: (stackButtonsView.bounds.height + 15) * scaleRatio).isActive = true
        pauseTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        resumeGameButton.heightAnchor.constraint(equalToConstant: stackButtonsView.bounds.height * scaleRatio).isActive = true
        resumeGameButton.widthAnchor.constraint(equalToConstant: stackButtonsView.bounds.width * 0.6).isActive = true
        restart.heightAnchor.constraint(equalToConstant: stackButtonsView.bounds.height * scaleRatio).isActive = true
        settings.heightAnchor.constraint(equalToConstant: stackButtonsView.bounds.height * scaleRatio).isActive = true
        backToMenu.heightAnchor.constraint(equalToConstant: stackButtonsView.bounds.height * scaleRatio).isActive = true
    }
    
    @objc func openAnswerView(button: UIButton){
        switch button {
        case restart:
            addSubview(restartAnswerView!)
            restartAnswerView?.animatedAdd()
        case backToMenu:
            addSubview(backToMenuAnswerView!)
            backToMenuAnswerView?.animatedAdd()
        default:
            break
        }
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    private func soundFXPlay(sound: String) {
        if !UserDefaults.standard.bool(forKey: "soundFX") {
            AudioController.sharedController.playFXSound(file: sound)
        }
    }

}
