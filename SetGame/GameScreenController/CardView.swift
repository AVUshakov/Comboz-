//
//  SetCardView.swift
//  Set: Table Game
//
//  Created by Alexander Ushakov on 19.05.2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var endDeal = 0
    
    @IBInspectable
    var cardBackgroundColor: UIColor = UIColor.white {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable
    var isSelected: Bool = false {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    var isMatched: Bool? {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    
    var newAddedCard: Bool = false
    
    var isFaceUp: Bool = true {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    
    @IBInspectable
    var symbolType: Int = 1 {
        didSet {
            switch symbolType {
                case 1: symbol = .romb
                case 2: symbol = .flash
                case 3: symbol = .oval
                default:
                    break
            }
        }
    }
    
    @IBInspectable
    var fillType: Int = 1 {
        didSet {
            switch fillType {
                case 1: fill = .solid
                case 2: fill = .stripe
                case 3: fill = .empty
                default:
                    break
            }
        }
    }
    
    @IBInspectable
    var colorType: Int = 1 {
        didSet {
            switch colorType {
                case 1: color = Colors.blue
                case 2: color = Colors.green
                case 3: color = Colors.red
                default:
                    break
            }
        }
    }
    
    private enum Symbols: Int {
        case romb
        case flash
        case oval
    }
    
    private enum Fill: Int {
        case solid
        case stripe
        case empty
    }
    
    @IBInspectable
    var count: Int = 3 {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    
    private var symbol = Symbols.flash {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    
    private var fill = Fill.stripe {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    
    private var color = Colors.green {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    
    private func drawShape(in rect: CGRect) {
        let path: UIBezierPath
        switch symbol {
        case .oval: path = quadPath(in: rect)
        case .flash: path = flashPath(in: rect)
        case .romb: path = trianglePath(in: rect)
        }
        path.lineWidth = 2.0
        path.stroke()
        
        switch fill {
        case .solid:
            path.fill()
        case .stripe:
            stripingShape(path: path, in: rect)
        default:
            break
        }
        
    }
    
    private func drawSymbols() {
        
        color.setFill()
        color.setStroke()
        
        switch count {
        case 1:
            let origin = CGPoint(x: cardFrame.minX, y: cardFrame.midY - pipHeight/2)
            let size = CGSize(width: cardFrame.width, height: pipHeight)
            let firstRect = CGRect(origin: origin, size: size)
            drawShape(in: firstRect)
        case 2:
            let origin = CGPoint(x: cardFrame.minX, y: cardFrame.midY  - interPipHeight / 2 - pipHeight)
            let size = CGSize(width: cardFrame.width, height: pipHeight)
            let firstRect = CGRect(origin: origin, size: size)
            drawShape(in: firstRect)
            let secondRect = firstRect.offsetBy(dx: 0, dy: pipHeight + interPipHeight)
            drawShape(in: secondRect)
        case 3:
            let origin  = CGPoint(x: cardFrame.minX, y: cardFrame.minY)
            let size = CGSize(width: cardFrame.width, height: pipHeight)
            let firstRect = CGRect(origin: origin, size: size)
            drawShape(in: firstRect)
            let secondRect = firstRect.offsetBy(dx: 0, dy: pipHeight + interPipHeight)
            drawShape(in: secondRect)
            let thirdRect = secondRect.offsetBy(dx: 0, dy: pipHeight + interPipHeight)
            drawShape(in: thirdRect)
        default:
            break
        }
    }
    
    private func stripesDraw(_ rect:CGRect) {
        let stripe = UIBezierPath()
        stripe.lineWidth = 1.0
        stripe.move(to: CGPoint(x: rect.minX, y: bounds.minY))
        stripe.addLine(to: CGPoint(x: rect.minX, y: bounds.maxY))
        let stripesCount = Int(cardFrame.width/interStripes)
        for _ in 1...stripesCount {
            let translation = CGAffineTransform(translationX: interStripes, y: 0)
            stripe.apply(translation)
            stripe.stroke()
        }
    }
    
    private func stripingShape(path: UIBezierPath, in rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        stripesDraw(rect)
        context?.restoreGState()
    }
    
    private func quadPath(in rect: CGRect) -> UIBezierPath {
        let quad = UIBezierPath()
        quad.move(to: CGPoint(x: rect.midX - rect.size.height * 0.5, y: rect.minY))
        quad.addLine(to: CGPoint(x: rect.midX + rect.size.height * 0.5, y: rect.minY))
        quad.addLine(to: CGPoint(x: rect.midX + rect.size.height * 0.5, y: rect.maxY))
        quad.addLine(to: CGPoint(x: rect.midX - rect.size.height * 0.5, y: rect.maxY))
        quad.addLine(to: CGPoint(x: rect.midX - rect.size.height * 0.5, y: rect.minY))
        quad.close()
        return quad
    }
    
    private func flashPath(in rect: CGRect) -> UIBezierPath {
        let flash = UIBezierPath()
        flash.move(to: CGPoint(x: rect.minX, y: rect.midY))
        flash.addLine(to: CGPoint(x: rect.minX + rect.size.width / 3, y: rect.minY))
        flash.addLine(to: CGPoint(x: rect.maxX - rect.size.width / 3, y: rect.midY))
        flash.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        flash.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        flash.addLine(to: CGPoint(x: rect.maxX - rect.size.width / 3, y: rect.maxY))
        flash.addLine(to: CGPoint(x: rect.minX + rect.size.width / 3, y: rect.midY))
        flash.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        flash.close()
        return flash
    }
    
    private func trianglePath(in rect: CGRect) -> UIBezierPath {
        let triangle = UIBezierPath()
        triangle.move(to: CGPoint(x: rect.midX, y: rect.minY))
        triangle.addLine(to: CGPoint(x: rect.maxX - rect.size.width / 5 , y: rect.maxY))
        triangle.addLine(to: CGPoint(x: rect.minX + rect.size.width / 5, y: rect.maxY))
        triangle.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        triangle.close()
        return triangle
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        cardBackgroundColor.setFill()
        roundedRect.fill()
        if isFaceUp {
            drawSymbols()
        } else {
            if let cardBackImage = UIImage(named: "cardBack", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
            }
        }
    }
    
    private func viewState() {
        isOpaque = false
        backgroundColor = .clear
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWith
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        if isSelected {
            layer.borderColor = Colors.selected
        }
        if let matched = isMatched {
            if matched {
                layer.borderColor = Colors.matched
            } else {
                layer.borderColor = Colors.miss
            }
        }

    }
    
    func copyCard() -> CardView {
        let copy = CardView()
        copy.colorType = colorType
        copy.fillType = fillType
        copy.count = count
        copy.symbolType = symbolType
        copy.isSelected = false
        
        copy.isFaceUp = isFaceUp
        copy.bounds = bounds
        copy.frame = frame
        copy.alpha = alpha
        copy.isOpaque = isOpaque
        
        return copy
    }
    
    func dealCardsFromDeckWithouAnimation(from deck: CGPoint) {
        let currentCenter = center
        let currentBounds = bounds
        center = deck
        alpha = 1
        self.bounds = currentBounds
        self.center = currentCenter
        isFaceUp = true
    }
    
    func dealCardsFromDeckAnimation(from deck: CGPoint, delay: TimeInterval) {
        let currentCenter = center
        let currentBounds = bounds
        center = deck
        alpha = 1
        isFaceUp = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6,
                                                       delay: delay,
                                                       options:[.curveEaseInOut],
                                                       animations: { self.bounds = currentBounds
                                                        self.center = currentCenter },
                                                       completion: {position in
                                                        UIView.transition(with: self,
                                                                          duration: 0.3,
                                                                          options: [.transitionFlipFromLeft],
                                                                          animations: {self.isFaceUp = true},
                                                                          completion: {finished in self.endDeal += 1})
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentMode = .redraw
        viewState()
    }
    
    private struct Colors {
        static let green = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        static let blue = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        static let red = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        static let selected = #colorLiteral(red: 0.9997687936, green: 0.6423431039, blue: 0.009596501477, alpha: 1).cgColor
        static let matched = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor
        static let miss = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor
    }
    
    private struct SizeRatio {
        static let cornerRadiusToBoundHeight: CGFloat = 0.06
        static let pipHeigtToCardHeight: CGFloat = 0.25
        static let maxCardSizeToBoundSize: CGFloat = 0.75
    }
    
    private struct AspectRatio {
        static let cardFrame: CGFloat = 0.60
    }
    
    private var maxCardFrame: CGRect {
        return bounds.zoomed(by: SizeRatio.maxCardSizeToBoundSize)
    }
    
    private var cardFrame: CGRect {
        let cardWidth = maxCardFrame.height * AspectRatio.cardFrame
        return maxCardFrame.insetBy(dx: (maxCardFrame.width - cardWidth) / 2, dy: 0)
    }
    
    private var pipHeight: CGFloat {
        return cardFrame.height * SizeRatio.pipHeigtToCardHeight
    }
    
    private var cornerRadius: CGFloat {
            return bounds.size.height * SizeRatio.cornerRadiusToBoundHeight
    }
    
    private var interPipHeight: CGFloat {
        return (cardFrame.height - (3 * pipHeight)) / 2
    }
    
    private var interStripes: CGFloat = 4.5
    private var borderWith: CGFloat = 5.0

}

extension CGRect {
    func zoomed(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}
