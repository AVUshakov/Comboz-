//
//  Card.swift
//  Set: Table Game
//
//  Created by Alexander Ushakov on 16.04.2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import Foundation

struct Card: Equatable, Codable {
    
    static func ==(lhs: Card, rhs:Card) -> Bool {
        return ((lhs.shape == rhs.shape) &&
                (lhs.count == rhs.count) &&
                (lhs.color == rhs.color) &&
                (lhs.fill == rhs.fill))
    }
    
    let shape: CardType
    let color: CardType
    let count: CardType
    let fill: CardType
    var isFaceUp = true
    
    enum CardType: Int, Codable {
        case variant1 = 1
        case variant2
        case variant3
        
        static var all: [CardType] {return [.variant1, .variant2, .variant3]}
        var idRawValue: Int {
            return (self.rawValue - 1)
        }

    }
    
    static func matchDetector(cards: [Card]) -> Bool {
        guard cards.count == 3 else {return false}
        let sum = [
            cards.reduce(0, {$0 + $1.shape.rawValue}),
            cards.reduce(0, {$0 + $1.color.rawValue}),
            cards.reduce(0, {$0 + $1.count.rawValue}),
            cards.reduce(0, {$0 + $1.fill.rawValue})
        ]
        return sum.reduce(true, {$0 && ($1 % 3 == 0)})
    }
}
