//
//  PurchaseView.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 12/07/2019.
//  Copyright © 2019 Alexander Ushakov. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseView: UIView, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    var buyButton = UIButton()
    var backButton = UIButton()
    var backgroundImage = UIImageView()
    var textLabel = UILabel()
    var stackView = UIStackView()
    
    var product : SKProduct?
    var productID = ""
    
    let scaleRatio : CGFloat = 0.12
    let edgeInset = UIEdgeInsets(top: 6, left: 10, bottom: 10, right: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        SKPaymentQueue.default().add(self)
        purchaseStatus()
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewSetup() {
    
        let background = UIImage(named: "menu_frame_iphoneX")
        backgroundImage.image = background
        backgroundImage.frame.size =  CGSize(width: frame.width * 0.8, height: frame.height * 0.6)
        backgroundImage.center = center
        addSubview(backgroundImage)
        
        stackView.frame = backgroundImage.frame
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        addSubview(stackView)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.attributedText = TextFont.AttributeText(_size: bounds.width * 0.5, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), text: "You can remove Ad from the game for 0.99$", shadows: true)
        textLabel.textAlignment = .center
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 200

        buyButton.setBackgroundImage(UIImage(named: "def_button"), for: .normal)
        buyButton.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "REMOVE AD", comment: ""), shadows: true), for: .normal)
        buyButton.addTarget(self, action: #selector(purchase), for: .touchUpInside)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        backButton.setBackgroundImage(UIImage(named: "def_button"), for: .normal)
        backButton.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: LocalizationSystem.instance.localizedStringForKey(key: "BACK", comment: ""), shadows: true), for: .normal)
        backButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(buyButton)
        stackView.addArrangedSubview(backButton)
        
        buttonsConstrainteParameters()
    }
    
    private func buttonsConstrainteParameters(){
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        textLabel.heightAnchor.constraint(equalToConstant: stackView.bounds.height * scaleRatio * 2).isActive = true
        buyButton.widthAnchor.constraint(equalToConstant: stackView.bounds.width * 0.6).isActive = true
        buyButton.heightAnchor.constraint(equalToConstant: stackView.bounds.height * scaleRatio).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: stackView.bounds.height * scaleRatio).isActive = true
    }
    
    @objc func purchase() {
        UserDefaults.standard.set(true, forKey: "Purchase")
        buyButton.setAttributedTitle(TextFont.AttributeText(_size: bounds.width, color: #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1), text: "Thank You!", shadows: true), for: .normal)
        buyButton.isEnabled = false
//        let payment = SKPayment(product: product!)
//        SKPaymentQueue.default().add(payment)
    }
    
    @objc func closeView() {
        self.animatedRemove()
        soundFXPlay(sound: AudioController.SoundFile.tapIn.rawValue)
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                let save = UserDefaults.standard
                save.set(true, forKey: "Purchase")
                save.synchronize()
                
            case SKPaymentTransactionState.failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            // MARK: will make allert
            default:
                break
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        if (products.count == 0) {
            
        } else {
            product = products[0]
        }
        
        let invalids = response.invalidProductIdentifiers
        
        for product in invalids {
            print("product not found: \(product)")
        }
    }
    
    func purchaseStatus() {
        if SKPaymentQueue.canMakePayments(){
            let request = SKProductsRequest(productIdentifiers: NSSet(object: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            // MARK - will make allert with trow to settings
        }
    }
    
    private func soundFXPlay(sound: String) {
        if !UserDefaults.standard.bool(forKey: "soundFX") {
            AudioController.sharedController.playFXSound(file: sound)
        }
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
