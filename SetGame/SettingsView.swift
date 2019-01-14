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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewSetup() {
        self.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        setButtons(button: music)
        setButtons(button: parallaxButton)
        setButtons(button: soundFX)
        
        self.addSubview(parallaxButton)
        self.addSubview(soundFX)
        self.addSubview(music)

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
        
        parallaxButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.bounds.width / 4).isActive = true
        parallaxButton.widthAnchor.constraint(equalToConstant: self.bounds.width / 6).isActive = true
        parallaxButton.heightAnchor.constraint(equalToConstant: self.bounds.height / 15).isActive = true
        parallaxButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        parallaxButton.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.height / 4).isActive = true
        
        soundFX.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.bounds.width / 4).isActive = true
        soundFX.widthAnchor.constraint(equalToConstant: self.bounds.width / 6).isActive = true
        soundFX.heightAnchor.constraint(equalToConstant: self.bounds.height / 15).isActive = true
        soundFX.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        soundFX.topAnchor.constraint(equalTo: parallaxButton.bottomAnchor, constant: 20).isActive = true
        
        music.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.bounds.width / 4).isActive = true
        music.widthAnchor.constraint(equalToConstant: self.bounds.width / 6).isActive = true
        music.heightAnchor.constraint(equalToConstant: self.bounds.height / 15).isActive = true
        music.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        music.topAnchor.constraint(equalTo: soundFX.bottomAnchor, constant: 20).isActive = true
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
            image.append("bluebutton")
            image.append("rosebutton")
        case music:
            image.append("bluebutton")
            image.append("rosebutton")
        case soundFX:
            image.append("bluebutton")
            image.append("rosebutton")
        default:
            break
        }
        return image
    }
    
    private func saveOption(name: String, button: UIButton) {
        let optionCase = UserDefaults.standard
        optionCase.set(button.isSelected, forKey: name)
    }
}
