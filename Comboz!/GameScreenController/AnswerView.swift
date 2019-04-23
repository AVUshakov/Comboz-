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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewSetup() {
        
        rectView.frame.size = CGSize(width: bounds.width * 0.8, height: bounds.height * 0.3)
        rectView.center = center
        rectView.addSubview(backgroundImage)
        
        backgroundImage.frame.size = rectView.bounds.size
        backgroundImage.image = UIImage(named: "frame_view")
        addSubview(rectView)
        
        stackButton.axis = .horizontal
        stackButton.spacing = 5
        stackButton.distribution = .fillEqually
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.addArrangedSubview(accept)
        stackButton.addArrangedSubview(cancel)
        rectView.addSubview(stackButton)
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 1
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        
        let stringAttributeText = [NSAttributedString.Key.font : UIFont(name: "junegull-regular", size: bounds.width * 0.05)!,
                                   NSAttributedString.Key.shadow: shadow,
                                   NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1)]
        
        textLabel.attributedText = NSAttributedString(string: "Are you sure?", attributes: stringAttributeText)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.alpha = 1
        rectView.addSubview(textLabel)
        
        cancel.setImage(UIImage(named: "no_btn"), for: .normal)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.imageView?.contentMode = .scaleAspectFill
        cancel.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        accept.setImage(UIImage(named: "yes_btn"), for: .normal)
        accept.translatesAutoresizingMaskIntoConstraints = false
        accept.imageView?.contentMode = .scaleAspectFill

        constraintsParameters()
    }
    
    @objc func closeView() {
        self.animatedRemove()
    }
    
    private func constraintsParameters() {
        
        textLabel.topAnchor.constraint(equalTo: rectView.topAnchor, constant: bounds.height * 0.03).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
       
        stackButton.widthAnchor.constraint(equalToConstant: bounds.width * 0.8).isActive = true
        stackButton.heightAnchor.constraint(equalToConstant: bounds.height / 6 ).isActive = true
        stackButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: bounds.height * 0.03).isActive = true
    }
 
}
