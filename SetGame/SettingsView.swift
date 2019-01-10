//
//  SettingsView.swift
//  SetGame
//
//  Created by Alexander Ushakov on 31/12/2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    
    var parallaxButton: UIButton = {
        let button = UIButton()
        button.setTitle(String("PARALAX : ON"), for: .normal)
        button.setTitle(String("PARALAX : OFF"), for: .selected)
        if button.isSelected {
            button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) }
        else {
            button.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushedButton), for: .touchUpInside)
        return button
    }()
    
    var soundFX: UIButton = {
        let button = UIButton()
        button.setTitle(String("FX : ON"), for: .normal)
        button.setTitle(String("FX : OFF"), for: .selected)
        if button.isSelected {
            button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) }
        else {
            button.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushedButton), for: .touchUpInside)
        return button
    }()
    var music: UIButton = {
        let button = UIButton()
        button.setTitle(String("MUSIC : ON"), for: .normal)
        button.setTitle(String("MUSIC : OFF"), for: .selected)
        if button.isSelected {
            button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) }
        else {
            button.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushedButton), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewSetup() {
        self.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        self.addSubview(parallaxButton)
        self.addSubview(soundFX)
        self.addSubview(music)

        buttonConstrainteParameters()

    }
    
    @objc func pushedButton(sender: UIButton) {
        if  !sender.isSelected {
            sender.isSelected = true
            sender.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        } else {
            sender.isSelected = false
            sender.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
        menuSettings(button: sender)
    }
    
    private func buttonConstrainteParameters() {
        
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
    
    func menuSettings(button: UIButton) {
        switch button {
        case parallaxButton:
            if button.isSelected {
                print("Paralax off")
           
            } else {
                print("Paralax on")
            }
        case music:
            if button.isSelected {
                print("Music off")
            } else {
                print("Music on")
            }
        case soundFX:
            if button.isSelected {
                print("SoundFX off")
            } else {
                print("SoundFX on")
            }
        default:
            break
        }
    }
}
