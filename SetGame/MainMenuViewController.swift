//
//  MainMenuViewController.swift
//  SetGame
//
//  Created by Alexander Ushakov on 09/12/2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    var animator: UIDynamicAnimator!
    
    var snap: UISnapBehavior!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var helpView: HelpView?
    
    var settingsView: SettingsView?
    
    override func viewWillAppear(_ animated: Bool) {
         mainMenuLogo.center = CGPoint(x: view.bounds.midX, y: view.bounds.minY)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        ViewFrameParameters.width = view.frame.width * 0.8
        ViewFrameParameters.height = view.frame.height * 0.8
        ViewFrameParameters.origin = CGPoint(x: (view.frame.width - ViewFrameParameters.width) / 2, y: (view.frame.height - ViewFrameParameters.height) / 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startVCMenuAnimation()
        animator = UIDynamicAnimator(referenceView: view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mainMenuLogo.center = CGPoint(x: view.bounds.midX, y: view.bounds.minY)
    }
    
    @IBOutlet weak var mainMenuLogo: UIImageView!
    
    @IBOutlet weak var stackMenuButtons: UIStackView!
    
    @IBOutlet weak var loadingBar: UIProgressView!
    
    @IBAction func playButton(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "SavedGameModel")
        pushButtonMenuAnimation()
    }
    
    @IBAction func helpButton(_ sender: UIButton) {
        helpViewAdding()
    }
    
    @IBAction func returnToMainMenuButton(_ sender: UIButton) {
    }
    @IBAction func settingsButton(_ sender: UIButton) {
        settingsViewAdding()
    }
    
    
    @IBAction func resumeGame(_ sender: UIButton) {
        pushButtonMenuAnimation()
    }
    
    private func startVCMenuAnimation() {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1,
                                                       delay: 0,
                                                       options:.curveEaseInOut,
                                                       animations: {
                                                        self.mainMenuLogo.center = self.view.center
                                                        print("VC Loadede")
        },
                                                       completion: nil)
    }
    
    private func pushButtonMenuAnimation() {
        let pointForStackButtonHidding = CGPoint(x: view.bounds.midX, y: view.bounds.maxY)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3,
                                                       delay: 0,
                                                       options:.curveEaseInOut,
                                                       animations: {
                                                        self.stackMenuButtons.center = pointForStackButtonHidding
                                                        self.stackMenuButtons.alpha = 0
                                                        },
                                                       completion: nil)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                       delay: 0,
                                                       options:.curveEaseInOut,
                                                       animations: {
                        self.mainMenuLogo.center = self.view.center
                        self.mainMenuLogo.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
                self.loadingBar.center = CGPoint(x: self.mainMenuLogo.center.x, y: self.mainMenuLogo.bounds.maxY + 200)
                self.loadingBar.alpha = 1
        },
                                                       completion: { finished in
                Timer.scheduledTimer(timeInterval: 0.003,
                                     target: self,
                                     selector: #selector(MainMenuViewController.updateLoadingBar),
                                     userInfo: nil,
                                     repeats: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(1.2)), execute: {
                    self.transitionViews()
                        })
                    }
                )
            }
    
    @objc func updateLoadingBar() {
        if loadingBar.progress != 1 {
            loadingBar.progress += 0.005
        }
    }
    
    private func transitionViews() {
        let gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.modalTransitionStyle = .crossDissolve
        self.present(gameVC, animated: true, completion: nil)
    }
    
    private func addParallaxToView(view: UIImageView) {
        let screenSize = view.bounds.size
        view.bounds.size = CGSize(width: screenSize.width * 1.2, height: screenSize.height * 1.2)
        
        let amount = 20
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        view.addMotionEffect(group)
    }
    
    private func helpViewAdding() {
        if helpView == nil {
            helpView = HelpView(frame: CGRect(origin: ViewFrameParameters.origin, size: CGSize(width: ViewFrameParameters.width, height: ViewFrameParameters.height)))
            if helpView != nil {
                view.addSubview(helpView!)
                
                snap = UISnapBehavior(item: helpView!, snapTo: CGPoint(x: view.center.x, y: view.center.y + 2))
                snap.damping = 0.1
                animator.addBehavior(snap)
            }
        } else {
            helpView!.removeFromSuperview()
            helpView = nil
        }
    }
    
    private func settingsViewAdding() {
        if settingsView == nil {
            settingsView = SettingsView(frame: CGRect(origin: ViewFrameParameters.origin, size: CGSize(width: ViewFrameParameters.width, height: ViewFrameParameters.height)))
            if settingsView != nil {
                view.addSubview(settingsView!)
                snap = UISnapBehavior(item: settingsView!, snapTo: CGPoint(x: view.center.x, y: view.center.y + 2))
                snap.damping = 0.1
                animator.addBehavior(snap)
            }
        } else {
            settingsView!.removeFromSuperview()
            settingsView = nil
        }
    }
}

struct ImageLabels {
    static let label1: CGFloat = 0.625
    static let spacingDx: CGFloat = 4.0
    static let spacingDy: CGFloat = 4.0
}

struct ViewFrameParameters {
    static var width = CGFloat()
    static var height = CGFloat()
    static var origin = CGPoint()
}


