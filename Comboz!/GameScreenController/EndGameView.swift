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
    var score = Int()
    var time = String()

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
        
        scoreText.attributedText = TextFont.AttributeText(_size: bounds.width * 0.15, color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), text: "Score")
        scoreText.translatesAutoresizingMaskIntoConstraints = false
        scoreText.alpha = 0
        addSubview(scoreText)
        
        scoreNumbers.attributedText = TextFont.AttributeText(_size: bounds.width * 0.12, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), text: "\(score)")
        scoreNumbers.translatesAutoresizingMaskIntoConstraints = false
        scoreNumbers.alpha = 0
        addSubview(scoreNumbers)
        
        timeText.attributedText = TextFont.AttributeText(_size: bounds.width * 0.15, color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), text: "Time")
        timeText.translatesAutoresizingMaskIntoConstraints = false
        timeText.alpha = 0
        addSubview(timeText)
        
        timeNumbers.attributedText = TextFont.AttributeText(_size: bounds.width * 0.12, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), text: "0:00:00")
        timeNumbers.translatesAutoresizingMaskIntoConstraints = false
        timeNumbers.alpha = 0
        addSubview(timeNumbers)
        
        restart.setBackgroundImage(UIImage(named: "restart_button"), for: .normal)
        restart.setAttributedTitle(TextFont.AttributeText(_size: bounds.width * 0.11, color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), text: "RESTART"), for: .normal)
        restart.translatesAutoresizingMaskIntoConstraints = false
        restart.alpha = 0
        restart.isEnabled = true
        addSubview(restart)
      
        backToMenu.setBackgroundImage(UIImage(named: "main_menu_button"), for: .normal)
        backToMenu.setAttributedTitle(TextFont.AttributeText(_size: bounds.width * 0.11, color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), text: "MAIN MENU"), for: .normal)

        backToMenu.translatesAutoresizingMaskIntoConstraints = false
        backToMenu.alpha = 0
        backToMenu.isEnabled = true
        addSubview(backToMenu)
        
        constraintsParameters()
        
        animation()
        
    }

    private func constraintsParameters() {
        
        scoreText.topAnchor.constraint(equalTo: topAnchor, constant: bounds.height * 0.1).isActive = true
        scoreText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scoreNumbers.topAnchor.constraint(equalTo: scoreText.bottomAnchor, constant: bounds.height * 0.01).isActive = true
        scoreNumbers.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        timeText.topAnchor.constraint(equalTo: scoreNumbers.bottomAnchor, constant: bounds.height * 0.015).isActive = true
        timeText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        timeNumbers.topAnchor.constraint(equalTo: timeText.bottomAnchor, constant: bounds.height * 0.01).isActive = true
        timeNumbers.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        restart.widthAnchor.constraint(equalToConstant: bounds.width * 0.8).isActive = true
        restart.heightAnchor.constraint(equalToConstant: bounds.height / 6 ).isActive = true
        restart.topAnchor.constraint(equalTo: timeNumbers.bottomAnchor, constant: bounds.height * 0.1).isActive = true
        restart.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        backToMenu.widthAnchor.constraint(equalToConstant: bounds.width * 0.8).isActive = true
        backToMenu.heightAnchor.constraint(equalToConstant: bounds.height / 6 ).isActive = true
        backToMenu.topAnchor.constraint(equalTo: restart.bottomAnchor, constant: bounds.height * 0.01).isActive = true
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

}
