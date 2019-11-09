//
//  AnswerView.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 21/03/2019.
//  Copyright © 2019 Alexander Ushakov. All rights reserved.
//

import UIKit

class AnswerView: UIView {
    
    var backgroundImage = UIImageView()
    var rectView = UIView()
    var textLabel = UILabel()
    var accept = UIButton()
    var cancel = UIButton()
    var stackButton = UIStackView()
    var stackView = UIStackView()
    let edgeInset = UIEdgeInsets(top: 6, left: 10, bottom: 10, right: 10)
    
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
                image = "qv_frame_iphoneX"
            case 896: //iphoneXS
                image = "qv_frame_iphoneX"
            default:
                image = "qv_frame_iphoneX"
            }
        } else if UIDevice().userInterfaceIdiom == .pad {
            image = "qv_frame_ipad"
        }
        
        rectView.frame.size = CGSize(width: bounds.width * 0.7, height: bounds.height * 0.2)
        rectView.center = center
        rectView.addSubview(backgroundImage)
        
        backgroundImage.frame.size = rectView.bounds.size
        backgroundImage.image = UIImage(named: image)
        addSubview(rectView)
        
        stackButton.axis = .horizontal
        stackButton.spacing = 16
        stackButton.distribution = .fillEqually
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.addArrangedSubview(accept)
        stackButton.addArrangedSubview(cancel)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(stackButton)
        rectView.addSubview(stackView)
        
        textLabel.attributedText = TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "ARE YOU SURE?", comment: ""), shadows: true)
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.alpha = 1
        
        cancel.setBackgroundImage(UIImage(named: "off_button"), for: .normal)
        cancel.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "NO", comment: ""), shadows: true), for: .normal)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        cancel.titleLabel?.adjustsFontSizeToFitWidth = true
        cancel.contentEdgeInsets = edgeInset
        
        accept.setBackgroundImage(UIImage(named: "on_button"), for: .normal)
        accept.setAttributedTitle(TextFont.AttributeText(_size: bounds.width - 0.03, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "YES", comment: ""), shadows: true), for: .normal)
        accept.translatesAutoresizingMaskIntoConstraints = false
        accept.titleLabel?.adjustsFontSizeToFitWidth = true
        accept.contentEdgeInsets = edgeInset

        constraintsParameters()
    }
    
    @objc func closeView() {
        self.animatedRemove()
    }
    
    private func constraintsParameters() {
        
        textLabel.heightAnchor.constraint(equalToConstant: bounds.height * 0.9).isActive = true
       
        stackButton.widthAnchor.constraint(equalToConstant: bounds.width * 0.6).isActive = true
        stackButton.heightAnchor.constraint(equalToConstant: bounds.height * 0.06 ).isActive = true
        
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    } 
}
