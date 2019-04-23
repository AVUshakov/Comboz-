//
//  PauseView.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 17/01/2019.
//  Copyright © 2019 Alexander Ushakov. All rights reserved.
//

import UIKit

class PauseView: UIView {
    
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
 
        backgroundImage.frame.size = bounds.size
        backgroundImage.image = UIImage(named: "frame_view")
        backgroundImage.alpha = 0.5
        addSubview(backgroundImage)
        
        stackButtonsView.translatesAutoresizingMaskIntoConstraints = false
        stackButtonsView.spacing = -10
        stackButtonsView.axis = .vertical
        stackButtonsView.alignment = .top
        addSubview(stackButtonsView)
        
        restart.setBackgroundImage(UIImage(named: "restart_button"), for: .normal)
        settings.setBackgroundImage(UIImage(named: "settings_button"), for: .normal)
        resumeGameButton.setBackgroundImage(UIImage(named: "resume_button"), for: .normal)
        backToMenu.setBackgroundImage(UIImage(named: "main_menu_button"), for: .normal)

        restart.translatesAutoresizingMaskIntoConstraints = false
        settings.translatesAutoresizingMaskIntoConstraints = false
        resumeGameButton.translatesAutoresizingMaskIntoConstraints = false
        backToMenu.translatesAutoresizingMaskIntoConstraints = false

        restart.addTarget(self, action: #selector(openAnswerView), for: .touchUpInside)
        settings.addTarget(self, action: #selector(settingsViewAdding), for: .touchUpInside)
        resumeGameButton.addTarget(self, action: #selector(closePauseView), for: .touchUpInside)
        backToMenu.addTarget(self, action: #selector(openAnswerView), for: .touchUpInside)
        
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
    }
    
    private func constraintsParameters() {
        
        stackButtonsView.widthAnchor.constraint(equalToConstant: bounds.width * 0.8).isActive = true
        stackButtonsView.heightAnchor.constraint(lessThanOrEqualToConstant: bounds.height).isActive = true
        stackButtonsView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackButtonsView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        restart.heightAnchor.constraint(equalToConstant: bounds.height / 6 ).isActive = true
        settings.heightAnchor.constraint(equalToConstant: bounds.height / 6).isActive = true
        resumeGameButton.heightAnchor.constraint(equalToConstant: bounds.height / 6).isActive = true
        backToMenu.heightAnchor.constraint(equalToConstant: bounds.height / 6).isActive = true
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
    }

}
