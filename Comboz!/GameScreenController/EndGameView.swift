//
//  EndGameView.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 13/03/2019.
//  Copyright © 2019 Alexander Ushakov. All rights reserved.
//

import UIKit

class EndGameView: UIView {
    
    var backgroundImage = UIImageView()
    var stackView = UIStackView()
    var scoreText = UILabel()
    var scoreNumbers = UILabel()
    var timeText = UILabel()
    var timeNumbers = UILabel()
    var newRecordLable = UILabel()
    var backToMenu = UIButton()
    var restart = UIButton()
    var score = Int() {
        didSet {
            scoreNumbers.attributedText = TextFont.AttributeText(_size: bounds.width * 1.2 ,
                                                                 color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1),
                                                                 text: "\(score)", shadows: true)
        }
    }
    var time = String() {
        didSet {
            timeNumbers.attributedText = TextFont.AttributeText(_size: bounds.width * 1.2,
                                                                color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1),
                                                                text: "\(time)", shadows: true)
        }
    }
    
    var scaleRatio : CGFloat = 0.12

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewSetup() {
        newRecordLable.frame.size = CGSize(width: frame.width * 0.8, height: frame.height * 0.1)
        newRecordLable.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        newRecordLable.attributedText = TextFont.AttributeText(_size: frame.width * 1.2, color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "NEW RECORD1", comment: ""), shadows: true)
        newRecordLable.center = center
        newRecordLable.textAlignment = .center
        newRecordLable.alpha = 0
        addSubview(newRecordLable)
        
        backgroundImage.frame = frame
        backgroundImage.frame.size = CGSize(width: frame.width * 0.8, height: frame.height * 0.6)
        backgroundImage.image = UIImage(named: "menu_frame_iphoneX")
        backgroundImage.center = center
        addSubview(backgroundImage)
        
        stackView.frame = CGRect(x: backgroundImage.frame.origin.x,
                                 y: backgroundImage.frame.origin.y,
                                 width: backgroundImage.frame.width,
                                 height: backgroundImage.frame.height * 0.6)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .center
        addSubview(stackView)
        
        scoreText.attributedText = TextFont.AttributeText(_size: bounds.width * 1.5, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "SCORE", comment: ""), shadows: true)
        scoreText.translatesAutoresizingMaskIntoConstraints = false
        scoreText.alpha = 0
        stackView.addArrangedSubview(scoreText)
        
        scoreNumbers.translatesAutoresizingMaskIntoConstraints = false
        scoreNumbers.alpha = 0
        stackView.addArrangedSubview(scoreNumbers)
        
        timeText.attributedText = TextFont.AttributeText(_size: bounds.width * 1.5, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "TIME", comment: ""), shadows: true)
        timeText.translatesAutoresizingMaskIntoConstraints = false
        timeText.alpha = 0
        stackView.addArrangedSubview(timeText)
        
        timeNumbers.translatesAutoresizingMaskIntoConstraints = false
        timeNumbers.alpha = 0
        stackView.addArrangedSubview(timeNumbers)
        
        restart.setBackgroundImage(UIImage(named: "def_button"), for: .normal)
        restart.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "RESTART", comment: ""), shadows: true), for: .normal)
        restart.translatesAutoresizingMaskIntoConstraints = false
        restart.titleLabel?.adjustsFontSizeToFitWidth = true
        restart.alpha = 0
        restart.isEnabled = true
        stackView.addArrangedSubview(restart)
      
        backToMenu.setBackgroundImage(UIImage(named: "back_button"), for: .normal)
        backToMenu.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "MAIN MENU", comment: ""), shadows: true), for: .normal)
        backToMenu.titleLabel?.adjustsFontSizeToFitWidth = true
        backToMenu.translatesAutoresizingMaskIntoConstraints = false
        backToMenu.alpha = 0
        backToMenu.isEnabled = true
        stackView.addArrangedSubview(backToMenu)
        
        constraintsParameters()
        
        animation()
    }
    
    func labelsSet(_score: Int, _time: String) {
        score = _score
        time = _time
    }

    private func constraintsParameters() {
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        scoreText.heightAnchor.constraint(equalToConstant: backgroundImage.bounds.height * scaleRatio).isActive = true
        scoreNumbers.heightAnchor.constraint(equalToConstant: backgroundImage.bounds.height * scaleRatio).isActive = true
        timeText.heightAnchor.constraint(equalToConstant: backgroundImage.bounds.height * scaleRatio).isActive = true
        timeNumbers.heightAnchor.constraint(equalToConstant: backgroundImage.bounds.height * scaleRatio).isActive = true
        restart.widthAnchor.constraint(equalToConstant: backgroundImage.bounds.width * 0.6).isActive = true
        restart.heightAnchor.constraint(equalToConstant: backgroundImage.bounds.height * scaleRatio).isActive = true
        backToMenu.widthAnchor.constraint(equalToConstant: backgroundImage.bounds.width * 0.6).isActive = true
        backToMenu.heightAnchor.constraint(equalToConstant: backgroundImage.bounds.height * scaleRatio).isActive = true
    }
    
    func animation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { self.scoreText.alpha = 1 },
                       completion: { finished in
                        self.newRecordLable.blinkEffect(_duration: 0.5)
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        let hiScore = UserDefaults.standard.integer(forKey: "HiScore")
                        if self.score == hiScore {
                            self.scoreNumbers.alpha = 1
                            self.scoreNumbers.transform = CGAffineTransform.identity.scaledBy(x: 1.4, y: 1.4)
                            self.newRecordLable.center = CGPoint(x: self.newRecordLable.center.x, y: self.backgroundImage.frame.minY - self.newRecordLable.frame.height * 0.5)
                            self.newRecordLable.alpha = 1
                        } else {
                            self.scoreNumbers.alpha = 1
                        }
        },
                       completion: { finished in
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.scoreNumbers.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                        self.timeText.alpha = 1 },
                       completion: { finished in
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { self.timeNumbers.alpha = 1 },
                       completion: { finished in
                                    self.backToMenu.center.y +=  self.backToMenu.bounds.height * 0.5
                                    self.restart.center.y +=  self.restart.bounds.height * 0.5
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { self.backToMenu.alpha = 1
                                     self.restart.alpha = 1
                                     self.backToMenu.center.y -=  self.backToMenu.bounds.height * 0.5
                                     self.restart.center.y -=  self.restart.bounds.height * 0.5
                        },
                       completion: nil)
                    })
                })
            })
        })
    }
    
    private func soundFXPlay(sound: String) {
        if !UserDefaults.standard.bool(forKey: "soundFX") {
            AudioController.sharedController.playFXSound(file: sound)
        }
    }

}
