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
    
    var parallaxButton = UIButton()
    var soundFX = UIButton()
    var music = UIButton()
    
    var rules = UIButton()
    var backButton = UIButton()
    
    var backgroundImage = UIImageView()
    var settigsLable = UILabel()
    
    var stackButton = UIStackView()
    
    var helpView: HelpView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if helpView?.window == nil {
            helpView = nil
        }
    }
    
    private func viewSetup() {
        backgroundImage.frame.size = bounds.size
        backgroundImage.image = UIImage(named: "frame_view")
        addSubview(backgroundImage)
        
        stackButton.axis = .vertical
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.spacing = -10
        addSubview(stackButton)
        
        settigsLable.attributedText = TextFont.AttributeText(_size: bounds.width * 0.11, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), text: "SETTINGS")
        settigsLable.translatesAutoresizingMaskIntoConstraints = false
        addSubview(settigsLable)
        
        setButtons(button: music)
        setButtons(button: parallaxButton)
        setButtons(button: soundFX)
        
        rules.setBackgroundImage(UIImage(named: "rules_button"), for: .normal)
        rules.setAttributedTitle(TextFont.AttributeText(_size: bounds.width * 0.11, color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), text: "Rules"), for: .normal)
        rules.addTarget(self, action: #selector(helpViewAdding), for: .touchUpInside)
        rules.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.setBackgroundImage(UIImage(named: "back_button"), for: .normal)
        backButton.setAttributedTitle(TextFont.AttributeText(_size: bounds.width * 0.11, color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), text: "BACK"), for: .normal)
        backButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackButton.addArrangedSubview(parallaxButton)
        stackButton.addArrangedSubview(soundFX)
        stackButton.addArrangedSubview(music)
        stackButton.addArrangedSubview(rules)
        stackButton.addArrangedSubview(backButton)

        buttonsConstrainteParameters()
    }
    
    private func setButtons(button: UIButton) {
        button.setBackgroundImage(UIImage(named: buttonsImage(button: button)[0]), for: .normal)
        button.setBackgroundImage(UIImage(named: buttonsImage(button: button)[1]), for: .selected)
        button.setAttributedTitle(TextFont.AttributeText(_size: bounds.width * 0.11, color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), text: "\(buttonsTitle(button: button))"), for: .normal)
        button.setAttributedTitle(TextFont.AttributeText(_size: bounds.width * 0.11, color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), text: "\(buttonsTitle(button: button))"), for: .selected)
        button.isSelected =  UserDefaults.standard.bool(forKey: codingKeys(button: button))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushedButton), for: .touchUpInside)
    }
    
    @objc func pushedButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        saveOption(name: codingKeys(button: sender), button: sender)
        soundSetter(button: sender)
    }
    
    private func buttonsConstrainteParameters() {
        
        settigsLable.heightAnchor.constraint(lessThanOrEqualToConstant: bounds.height * 0.06).isActive = true
        settigsLable.widthAnchor.constraint(lessThanOrEqualToConstant: bounds.width * 0.5).isActive = true
        settigsLable.topAnchor.constraint(equalTo: topAnchor, constant: bounds.height * 0.07).isActive = true
        settigsLable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        stackButton.heightAnchor.constraint(lessThanOrEqualToConstant: bounds.height).isActive = true
        stackButton.widthAnchor.constraint(lessThanOrEqualToConstant: bounds.width * 0.8).isActive = true
        stackButton.topAnchor.constraint(equalTo: settigsLable.bottomAnchor, constant: bounds.height * 0.03).isActive = true
        stackButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        parallaxButton.heightAnchor.constraint(equalToConstant: self.bounds.height / 6).isActive = true
        soundFX.heightAnchor.constraint(equalToConstant: self.bounds.height / 6).isActive = true
        music.heightAnchor.constraint(equalToConstant: self.bounds.height / 6).isActive = true
        rules.heightAnchor.constraint(equalToConstant: self.bounds.height / 6).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.bounds.height / 6).isActive = true
        
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
        case parallaxButton:
            codingKey = "paralax"
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
        case parallaxButton:
            image.append("parallax_on_button")
            image.append("parallax_off_button")
        case music:
            image.append("music_on_button")
            image.append("music_off_button")
        case soundFX:
            image.append("soundfx_on_button")
            image.append("soundfx_off_button")
        default:
            break
        }
        return image
    }
    
    private func buttonsTitle(button: UIButton) -> String {
        var text = String()
        switch button {
        case parallaxButton:
            text = "PARALLAX"
        case music:
            text = "MUSIC"
        case soundFX:
            text = "SOUND FX"
        case rules:
            text = "RULES"
        case backButton:
            text = "BACK"
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
    }
        
    @objc func helpViewAdding() {
        if helpView == nil {
            helpView = HelpView(frame: self.bounds)
            if helpView != nil {
                addSubview(helpView!)
                helpView?.animatedAdd()
            }
        }
    }
}
