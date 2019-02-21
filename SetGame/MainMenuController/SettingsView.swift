//
//  SettingsView.swift
//  SetGame
//
//  Created by Alexander Ushakov on 31/12/2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    
    var parallaxButton = UIButton()
    var soundFX = UIButton()
    var music = UIButton()
    
    var rules: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rules_button"), for: .normal)
        button.addTarget(self, action: #selector(helpViewAdding), for: .touchUpInside)
        return button
    }()
    var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back_button"), for: .normal)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return button
    }()
    
    var backgroundImage = UIImageView()
    var settigsImage = UIImageView()
    
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
    
    private func viewSetup() {
        backgroundImage.frame.size = bounds.size
        backgroundImage.image = UIImage(named: "frame_view")
        addSubview(backgroundImage)
        
        stackButton.axis = .vertical
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.spacing = -10
        addSubview(stackButton)
        
        settigsImage.image = UIImage(named: "settings_image")
        settigsImage.translatesAutoresizingMaskIntoConstraints = false
        settigsImage.contentMode = .scaleAspectFill
        
        addSubview(settigsImage)
        
        setButtons(button: music)
        setButtons(button: parallaxButton)
        setButtons(button: soundFX)
        
        rules.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false


        
        stackButton.addArrangedSubview(parallaxButton)
        stackButton.addArrangedSubview(soundFX)
        stackButton.addArrangedSubview(music)
        stackButton.addArrangedSubview(rules)
        stackButton.addArrangedSubview(backButton)

        
        buttonsConstrainteParameters()

    }
    
    private func setButtons(button: UIButton) {
        button.setImage(UIImage(named: buttonsImage(button: button)[0]), for: .normal)
        button.setImage(UIImage(named: buttonsImage(button: button)[1]), for: .selected)
        button.isSelected =  UserDefaults.standard.bool(forKey: codingKeys(button: button))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushedButton), for: .touchUpInside)
    }
    
    @objc func pushedButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        saveOption(name: codingKeys(button: sender), button: sender)
        print(codingKeys(button: sender))
    }
    
    private func buttonsConstrainteParameters() {
        
        settigsImage.heightAnchor.constraint(lessThanOrEqualToConstant: bounds.height * 0.06).isActive = true
        settigsImage.widthAnchor.constraint(lessThanOrEqualToConstant: bounds.width * 0.5).isActive = true
        settigsImage.topAnchor.constraint(equalTo: topAnchor, constant: bounds.height * 0.1).isActive = true
        settigsImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        stackButton.heightAnchor.constraint(lessThanOrEqualToConstant: bounds.height).isActive = true
        stackButton.widthAnchor.constraint(lessThanOrEqualToConstant: bounds.width * 0.8).isActive = true
        stackButton.topAnchor.constraint(equalTo: settigsImage.bottomAnchor, constant: bounds.height * 0.03).isActive = true
        stackButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        parallaxButton.heightAnchor.constraint(equalToConstant: self.bounds.height / 6).isActive = true
        soundFX.heightAnchor.constraint(equalToConstant: self.bounds.height / 6).isActive = true
        music.heightAnchor.constraint(equalToConstant: self.bounds.height / 6).isActive = true
        rules.heightAnchor.constraint(equalToConstant: self.bounds.height / 6).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.bounds.height / 6).isActive = true
        
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
    
    private func saveOption(name: String, button: UIButton) {
        let optionCase = UserDefaults.standard
        optionCase.set(button.isSelected, forKey: name)
    }
    
    @objc func closeView() {
        self.removeFromSuperview()
    }
    
    @objc func helpViewAdding() {
        if helpView == nil {
            helpView = HelpView(frame: self.bounds)
            if helpView != nil {
                addSubview(helpView!)
            }
        } else {
            helpView!.removeFromSuperview()
            helpView = nil
        }
    }
}
