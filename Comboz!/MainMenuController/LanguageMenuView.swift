//
//  LanguageMenuView.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 26.10.2019.
//  Copyright © 2019 Alexander Ushakov. All rights reserved.
//

import UIKit
import AVFoundation

class LanguageMenuView: UIView {
    
    var englishLng = UIButton()
    var spanishLng = UIButton()
    var frenchLng = UIButton()
    var russianLng = UIButton()
    var chineseLng = UIButton()
    
    var languageButtons = [UIButton]()
    
    var backButton = UIButton()
       
    var backgroundImage = UIImageView()
    
       
    let scaleRatio : CGFloat = 0.12
    let edgeInset = UIEdgeInsets(top: 6, left: 10, bottom: 10, right: 10)
       
    var stackButton = UIStackView()
              
    var oldRect = CGRect()
       
    struct LocalizedText {
        static let english         = NSLocalizedString("ENGLISH", comment: "en_button")
        static let spanish         = NSLocalizedString("ESPAÑOL", comment: "es_button")
        static let french          = NSLocalizedString("FRANÇAIS", comment: "music_button")
        static let russian         = NSLocalizedString("РУССКИЙ", comment: "rules_button")
        static let chinese         = NSLocalizedString("中文", comment: "settigsLable_button")
    }
       
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
       
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
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
           
        stackButton.frame = backgroundImage.frame
        stackButton.axis = .vertical
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.spacing = 10
        addSubview(stackButton)
           
        setButtons(button: frenchLng)
        setButtons(button: englishLng)
        setButtons(button: spanishLng)
        setButtons(button: russianLng)
        setButtons(button: chineseLng)
           
        
        backButton.setBackgroundImage(UIImage(named: "back_button"), for: .normal)
        backButton.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "BACK", comment: ""), shadows: true), for: .normal)
        backButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
        backButton.contentEdgeInsets = edgeInset

        stackButton.addArrangedSubview(englishLng)
        stackButton.addArrangedSubview(spanishLng)
        stackButton.addArrangedSubview(frenchLng)
        stackButton.addArrangedSubview(russianLng)
        stackButton.addArrangedSubview(chineseLng)
        stackButton.addArrangedSubview(backButton)

        buttonsConstrainteParameters()
       }
       
    private func setButtons(button: UIButton) {
        button.setBackgroundImage(UIImage(named: "def_button"), for: .normal)
        button.setBackgroundImage(UIImage(named: "on_button"), for: .selected)
        button.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "\(buttonsTitle(button: button))", shadows: true), for: .normal)
        button.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "\(buttonsTitle(button: button))", shadows: true), for: .selected)
        button.isSelected =  UserDefaults.standard.bool(forKey: codingKeys(button: button))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushedButton), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentEdgeInsets = edgeInset
        languageButtons.append(button)
    }
       
    @objc func pushedButton(sender: UIButton) {
        
        for button in languageButtons {
            if button == sender {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
            saveOption(name: codingKeys(button: button), button: button)
        }
        
        switch sender {
        case russianLng:
            LocalizationSystem.instance.setLanguage(languageCode: "ru")
        case englishLng:
            LocalizationSystem.instance.setLanguage(languageCode: "en")
        case spanishLng:
            LocalizationSystem.instance.setLanguage(languageCode: "es")
        case frenchLng:
            LocalizationSystem.instance.setLanguage(languageCode: "fr")
        case chineseLng:
            LocalizationSystem.instance.setLanguage(languageCode: "zh")
        default:
            break
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "languge_changed"), object: nil)
        
        print("system  " + Locale.current.languageCode!)
        print("app " + LocalizationSystem.instance.getLanguage())
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
       
    private func buttonsConstrainteParameters() {
           
        stackButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        chineseLng.heightAnchor.constraint(equalToConstant: (stackButton.bounds.height + 15) * scaleRatio).isActive = true
        chineseLng.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        englishLng.heightAnchor.constraint(equalToConstant: stackButton.bounds.height * scaleRatio).isActive = true
        englishLng.widthAnchor.constraint(equalToConstant: stackButton.bounds.width * 0.6).isActive = true
        spanishLng.heightAnchor.constraint(equalToConstant: stackButton.bounds.height * scaleRatio).isActive = true
        frenchLng.heightAnchor.constraint(equalToConstant: stackButton.bounds.height * scaleRatio).isActive = true
        russianLng.heightAnchor.constraint(equalToConstant: stackButton.bounds.height * scaleRatio).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: stackButton.bounds.height * scaleRatio).isActive = true
           
    }

       
    private func codingKeys(button: UIButton) -> String {
        var codingKey = String()
        switch button {
        case englishLng:
            codingKey = "en"
        case frenchLng:
            codingKey = "fr"
        case spanishLng:
            codingKey = "es"
        case russianLng:
            codingKey = "ru"
        case chineseLng:
            codingKey = "zh"
        default:
            break
        }
        return codingKey
    }
       
    private func buttonsTitle(button: UIButton) -> String {
        var text = String()
        switch button {
        case englishLng:
            text = LocalizedText.english
        case frenchLng:
            text = LocalizedText.french
        case spanishLng:
            text = LocalizedText.spanish
        case russianLng:
            text = LocalizedText.russian
        case chineseLng:
            text = LocalizedText.chinese
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
   
    private func soundFXPlay(sound: String) {
        if !UserDefaults.standard.bool(forKey: "soundFX") {
            AudioController.sharedController.playFXSound(file: sound)
        }
    }

}

extension String {
    func localizableString(loc: String) -> String{
        let path = Bundle.main.path(forResource: loc, ofType: "iproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
