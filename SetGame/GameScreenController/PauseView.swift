//
//  PauseView.swift
//  SetGame
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
    
    var helpView: HelpView?
    var settingsView: SettingsView?
    
    var animator: UIDynamicAnimator!
    var snap: UISnapBehavior!

    var backgroundImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backToMainMenu() {
        print("exit")
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
        
        restart.setImage(UIImage(named: "restart_button"), for: .normal)
        settings.setImage(UIImage(named: "settings_button"), for: .normal)
        resumeGameButton.setImage(UIImage(named: "resume_button"), for: .normal)
        backToMenu.setImage(UIImage(named: "main_menu_button"), for: .normal)

        restart.translatesAutoresizingMaskIntoConstraints = false
        settings.translatesAutoresizingMaskIntoConstraints = false
        resumeGameButton.translatesAutoresizingMaskIntoConstraints = false
        backToMenu.translatesAutoresizingMaskIntoConstraints = false

        settings.addTarget(self, action: #selector(settingsViewAdding), for: .touchUpInside)
        resumeGameButton.addTarget(self, action: #selector(closePauseView), for: .touchUpInside)
        
        
        stackButtonsView.addArrangedSubview(resumeGameButton)
        stackButtonsView.addArrangedSubview(restart)
        stackButtonsView.addArrangedSubview(settings)
        stackButtonsView.addArrangedSubview(backToMenu)
        
        constraintsParameters()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.9)), execute: {
//            self.snap = UISnapBehavior(item: self.stackButtonsView, snapTo: CGPoint(x: self.center.x, y: self.center.y + 2))
//            self.snap.damping = 0.1
//            self.animator.addBehavior(self.snap)
//        })
    }
    
    @objc func closePauseView() {
        self.removeFromSuperview()
    }
    
    @objc func settingsViewAdding() {
        if settingsView == nil {
            settingsView = SettingsView(frame: self.bounds)
            if settingsView != nil {
                addSubview(settingsView!)
            }
        } else {
            settingsView!.removeFromSuperview()
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

}
