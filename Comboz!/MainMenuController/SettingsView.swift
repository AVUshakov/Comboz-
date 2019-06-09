//
//  SettingsView.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 31/12/2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsView: UIView {
    
    var vibration = UIButton()
    var soundFX = UIButton()
    var music = UIButton()
    
    var rules = UIButton()
    var backButton = UIButton()
    
    var backgroundImage = UIImageView()
    var settingsLable = UILabel()
    
    let scaleRatio : CGFloat = 0.12
    
    var stackButton = UIStackView()
    
    var helpView: HelpView?
    
    var oldRect = CGRect()
    
    struct LocalizedText {
        static let parallaxButton  = NSLocalizedString("VIBRATION", comment: "vibration_button")
        static let soundFX         = NSLocalizedString("SOUND FX", comment: "soundFX_button")
        static let music           = NSLocalizedString("MUSIC", comment: "music_button")
        static let rules           = NSLocalizedString("RULES", comment: "rules_button")
        static let backButton      = NSLocalizedString("BACK", comment: "backButton_button")
        static let settigsLable    = NSLocalizedString("SETTINGS", comment: "settigsLable_button")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if helpView?.window == nil && helpView != nil {
            helpView = nil
        }
    }
    
    private func viewSetup() {
                
        backgroundImage.frame.size = CGSize(width: frame.width * 0.8, height: frame.height * 0.6)
        backgroundImage.center = center
        backgroundImage.image = UIImage(named: "Menu")
        addSubview(backgroundImage)
        
        stackButton.frame = backgroundImage.frame
        stackButton.axis = .vertical
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.spacing = 10
        addSubview(stackButton)
        
        settingsLable.attributedText = TextFont.AttributeText(_size: bounds.width * 1.4, color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), text: LocalizedText.settigsLable)
        settingsLable.adjustsFontSizeToFitWidth = true
        settingsLable.translatesAutoresizingMaskIntoConstraints = false
        settingsLable.textAlignment = .center
        
        setButtons(button: music)
        setButtons(button: vibration)
        setButtons(button: soundFX)
        
        rules.setBackgroundImage(UIImage(named: "Def_button"), for: .normal)
        rules.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizedText.rules), for: .normal)
        rules.addTarget(self, action: #selector(helpViewAdding), for: .touchUpInside)
        rules.translatesAutoresizingMaskIntoConstraints = false
        rules.titleLabel?.adjustsFontSizeToFitWidth = true
        
        backButton.setBackgroundImage(UIImage(named: "Back_button"), for: .normal)
        backButton.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), text: LocalizedText.backButton), for: .normal)
        backButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true

        
        stackButton.addArrangedSubview(settingsLable)
        stackButton.addArrangedSubview(vibration)
        stackButton.addArrangedSubview(soundFX)
        stackButton.addArrangedSubview(music)
        stackButton.addArrangedSubview(rules)
        stackButton.addArrangedSubview(backButton)

        buttonsConstrainteParameters()
    }
    
    private func setButtons(button: UIButton) {
        button.setBackgroundImage(UIImage(named: buttonsImage(button: button)[0]), for: .normal)
        button.setBackgroundImage(UIImage(named: buttonsImage(button: button)[1]), for: .selected)
        button.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "\(buttonsTitle(button: button))"), for: .normal)
        button.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "\(buttonsTitle(button: button))"), for: .selected)
        button.isSelected =  UserDefaults.standard.bool(forKey: codingKeys(button: button))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushedButton), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @objc func pushedButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        saveOption(name: codingKeys(button: sender), button: sender)
        soundSetter(button: sender)
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    private func buttonsConstrainteParameters() {
        
        stackButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        settingsLable.heightAnchor.constraint(equalToConstant: (stackButton.bounds.height + 15) * scaleRatio).isActive = true
        settingsLable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        vibration.heightAnchor.constraint(equalToConstant: stackButton.bounds.height * scaleRatio).isActive = true
        vibration.widthAnchor.constraint(equalToConstant: stackButton.bounds.width * 0.6).isActive = true
        soundFX.heightAnchor.constraint(equalToConstant: stackButton.bounds.height * scaleRatio).isActive = true
        music.heightAnchor.constraint(equalToConstant: stackButton.bounds.height * scaleRatio).isActive = true
        rules.heightAnchor.constraint(equalToConstant: stackButton.bounds.height * scaleRatio).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: stackButton.bounds.height * scaleRatio).isActive = true
        
    }
    
    private func soundSetter(button: UIButton){
        switch button {
        case music:
            if !music.isSelected {
                AudioController.sharedController.playBackgroundMusic(file: AudioController.SoundFile.tapIn.rawValue)
            } else {
                AudioController.sharedController.backgroundMusic.stop()
            }
        default:
            break
        }
    }
    
    private func codingKeys(button: UIButton) -> String {
        var codingKey = String()
        switch button {
        case vibration:
            codingKey = "vibration"
        case music:
            codingKey = "music"
        case soundFX:
            codingKey = "soundFX"
        default:
            break
        }
        return codingKey
    }
    
    private func buttonsImage(button: UIButton) -> [String] {
        var image = [String]()
        switch button {
        case vibration:
            image.append("On_button")
            image.append("Off_button")
        case music:
            image.append("On_button")
            image.append("Off_button")
        case soundFX:
            image.append("On_button")
            image.append("Off_button")
        default:
            break
        }
        return image
    }
    
    private func buttonsTitle(button: UIButton) -> String {
        var text = String()
        switch button {
        case vibration:
            text = LocalizedText.parallaxButton
        case music:
            text = LocalizedText.music
        case soundFX:
            text = LocalizedText.soundFX
        default:
            break
        }
        return text
    }
    
    private func saveOption(name: String, button: UIButton) {
        let optionCase = UserDefaults.standard
        optionCase.set(button.isSelected, forKey: name)
    }
    
    private func audioController(audioFile: AVAudioPlayer, button: UIButton) {
        if !button.isSelected {
            audioFile.play()
        } else {
            audioFile.stop()
        }
    }
    
    @objc func closeView() {
        self.animatedRemove()
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    @objc func deleteHelpView(){
            helpView?.animatedRemove()
            helpView = nil
    }
        
    @objc func helpViewAdding() {
        if helpView == nil {
            
            helpView = HelpView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: bounds.width * 0.9,
                                              height: bounds.height * 0.8))
            helpView?.center = center
            addSubview(helpView!)
            helpView?.animatedAdd()
            soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = CGSize()
        if helpView != nil {
            size = helpView!.frame.size
        }
        return size
    }
    
    private func soundFXPlay(sound: String) {
        if !UserDefaults.standard.bool(forKey: "soundFX") {
            AudioController.sharedController.playFXSound(file: sound)
        }
    }
}
