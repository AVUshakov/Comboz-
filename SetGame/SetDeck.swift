//
//  Set.swift
//  Set: Table Game
//
//  Created by Alexander Ushakov on 16.04.2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import Foundation

struct SetDeck {

    var cards = [Card]()
    
    init() {
        for shape in Card.CardType.all {
            for color in Card.CardType.all {
                for fill in Card.CardType.all {
                    for count in Card.CardType.all {
                        cards.append(Card(shape: shape, color: color, count: count, fill: fill, isFaceUp: true))
                    }
                }
            }
        }
    }
    
    mutating func showCard() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
    
    mutating func cardsShuffle() {
        for index in cards.indices {
            let random = cards.count.arc4random
            let buffer = cards[random]
            cards[random] = cards[index]
            cards[index] = buffer
        }
    }
}
