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
    var scoreText = UILabel()
    var scoreNumbers = UILabel()
    var timeText = UILabel()
    var timeNumbers = UILabel()
    var backToMenu = UIButton()
    var restart = UIButton()
    var score = Int() {
        didSet {
            scoreNumbers.attributedText = TextFont.AttributeText(_size: bounds.width * 1.2 ,
                                                                 color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1),
                                                                 text: "\(score)")
        }
    }
    var time = String() {
        didSet {
            timeNumbers.attributedText = TextFont.AttributeText(_size: bounds.width * 1.2,
                                                                color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1),
                                                                text: "\(time)")
        }
    }
    
    var scaleRatio : CGFloat = 0.12
    
    struct LocalizedText {
        static let scoreText  = NSLocalizedString("SCORE", comment: "scoreText_button")
        static let backToMenu = NSLocalizedString("MAIN MENU", comment: "backToMenu_button")
        static let timeText   = NSLocalizedString("TIME", comment: "timeText_button")
        static let restart    = NSLocalizedString("RESTART", comment: "restart_button")
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
        backgroundImage.frame.size = CGSize(width: frame.width * 0.8, height: frame.height * 0.6)
        backgroundImage.image = UIImage(named: "Menu")
        backgroundImage.center = center
        addSubview(backgroundImage)
        
        scoreText.attributedText = TextFont.AttributeText(_size: bounds.width * 1.5, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizedText.scoreText)
        scoreText.translatesAutoresizingMaskIntoConstraints = false
        scoreText.alpha = 0
        addSubview(scoreText)
        
        scoreNumbers.translatesAutoresizingMaskIntoConstraints = false
        scoreNumbers.alpha = 0
        addSubview(scoreNumbers)
        
        timeText.attributedText = TextFont.AttributeText(_size: bounds.width * 1.5, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizedText.timeText)
        timeText.translatesAutoresizingMaskIntoConstraints = false
        timeText.alpha = 0
        addSubview(timeText)
        
        timeNumbers.translatesAutoresizingMaskIntoConstraints = false
        timeNumbers.alpha = 0
        addSubview(timeNumbers)
        
        restart.setBackgroundImage(UIImage(named: "On_button"), for: .normal)
        restart.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizedText.restart), for: .normal)
        restart.translatesAutoresizingMaskIntoConstraints = false
        restart.titleLabel?.adjustsFontSizeToFitWidth = true
        restart.alpha = 0
        restart.isEnabled = true
        addSubview(restart)
      
        backToMenu.setBackgroundImage(UIImage(named: "Back_button"), for: .normal)
        backToMenu.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), text: LocalizedText.backToMenu), for: .normal)
        backToMenu.titleLabel?.adjustsFontSizeToFitWidth = true
        backToMenu.translatesAutoresizingMaskIntoConstraints = false
        backToMenu.alpha = 0
        backToMenu.isEnabled = true
        addSubview(backToMenu)
        
        constraintsParameters()
        
        animation()
    }
    
    func labelsSet(_score: Int, _time: String) {
        score = _score
        time = _time
    }

    private func constraintsParameters() {
        
        scoreText.topAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: backgroundImage.bounds.height * 0.1).isActive = true
        scoreText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scoreNumbers.topAnchor.constraint(equalTo: scoreText.bottomAnchor, constant: backgroundImage.bounds.height * 0.01).isActive = true
        scoreNumbers.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        timeText.topAnchor.constraint(equalTo: scoreNumbers.bottomAnchor, constant: backgroundImage.bounds.height * 0.015).isActive = true
        timeText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        timeNumbers.topAnchor.constraint(equalTo: timeText.bottomAnchor, constant: backgroundImage.bounds.height * 0.01).isActive = true
        timeNumbers.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        restart.widthAnchor.constraint(equalToConstant: backgroundImage.bounds.width * 0.6).isActive = true
        restart.heightAnchor.constraint(equalToConstant: backgroundImage.bounds.height * scaleRatio ).isActive = true
        restart.topAnchor.constraint(equalTo: timeNumbers.bottomAnchor, constant: backgroundImage.bounds.height * 0.03).isActive = true
        restart.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        backToMenu.widthAnchor.constraint(equalToConstant: backgroundImage.bounds.width * 0.6).isActive = true
        backToMenu.heightAnchor.constraint(equalToConstant: backgroundImage.bounds.height * scaleRatio ).isActive = true
        backToMenu.topAnchor.constraint(equalTo: restart.bottomAnchor, constant: 10).isActive = true
        backToMenu.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    private func animation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { self.scoreText.alpha = 1},
                       completion: { finished in
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { self.scoreNumbers.alpha = 1 },
                       completion: { finished in
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { self.timeText.alpha = 1 },
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
