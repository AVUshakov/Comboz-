//
//  GameModel.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 23.04.2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import Foundation

class GameModel: Codable {
    
    private(set) var cardsOnTable = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var cardForMatching = [Card]()
    private(set) var removedCardFromTable = [Card]()

    var hintCards = [Int]()
    
    private var cardsDeck = CardsDeck()
   
    var score = 0
    var secondCounter = 0.0
    var bonusCounter = 0.0
    var gameIsResume = false
    var hintUsed = false
    var bonusTime = false
    
    var cardsDeckCount: Int {
        return cardsDeck.cards.count
    }
   
    
    var matchDetector: Bool? {
        get {
            guard cardForMatching.count == 3 else {return nil}
            return Card.matchDetector(cards: cardForMatching)
        }
        set {
            if newValue != nil {
                cardForMatching = selectedCards
                selectedCards.removeAll()
            } else {
                cardForMatching.removeAll()
            }
            bonusTime = false
            hintCards.removeAll()
        }
    }

    var endGameDetector: Bool {
        get {
            guard !checkMatchOnTable() && cardsDeckCount == 0 else {return false}
            return true
        }
    }
    
    func choosenCard(index: Int) {
        let choosenCard = cardsOnTable[index]
        if !removedCardFromTable.contains(choosenCard) && !cardForMatching.contains(choosenCard) {
            if selectedCards.count == 2, !selectedCards.contains(choosenCard) {
                selectedCards += [choosenCard]
                matchDetector = Card.matchDetector(cards: selectedCards)
            } else {
                selectedCards.inOut(element: choosenCard)
            }
        }
        
    }
    
    func takeCardsFromDeck() {
        if cardsOnTable.count < Constants.deckCount {
            for _ in 0...2 {
                if let card = cardsDeck.showCard() {
                    cardsOnTable += [card]
                }
            }
        }
    }
    
    func showHintCard() {
        if !hintCards.isEmpty && selectedCards.count <= 2  {
            selectedCards.append(cardsOnTable[hintCards.remove(at: hintCards.count - 1)])
            hintUsed = true
        }
        if selectedCards.count == 3 {
            matchDetector = Card.matchDetector(cards: selectedCards)
        }
    }
    
    func matchingResult() {
        if matchDetector != nil {
            if matchDetector! {
                for i in cardsOnTable.indices {
                    if cardForMatching.contains(cardsOnTable[i]) {
                        cardsOnTable[i].isFaceUp = false
                    }
                }
                guard hintUsed else {
                    if bonusCounter <= 10.0 {
                        bonusTime = true
                        score += 5
                    } else {
                        bonusTime = false
                        score += 1
                    }
                    return
                }
            } else {
                if score > 0 {
                    score -= 1
                }
            }
            hintUsed = false
        }
        
    }
    
    private func checkMatchOnTable() -> Bool {
        var matchDetected = false
            for i in 0..<cardsOnTable.count {
                for j in (i+1)..<cardsOnTable.count {
                    for k in (j+1)..<cardsOnTable.count {
                        let checkingCards = [cardsOnTable[i], cardsOnTable[j], cardsOnTable[k]]
                        if Card.matchDetector(cards: checkingCards) {
                            if hintCards.isEmpty {
                               hintCards = [i, j, k]
                            }
                            matchDetected = true
                        }
                    }
                }
            }
        return matchDetected
    }
    
    func flipCards() {
        for i in cardsOnTable.indices {
            cardsOnTable[i].isFaceUp = true
        }
    }
        
    func removeCards() {
        if matchDetector != nil {
            if matchDetector!{
                if !cardsDeck.cards.isEmpty && cardsOnTable.count < 13 {
                    for i in cardsOnTable.indices {
                        if cardsOnTable[i].isFaceUp == false {
                            cardsOnTable.insert(cardsDeck.cards.remove(at: cardsDeck.cards.count.arc4random), at: i)
                            cardsOnTable.remove(at: i + 1)
                        }
                    }
                } else {
                    cardsOnTable.removeArray(elements: cardForMatching)
                }
                hintCards.removeAll()
            }
            matchDetector = nil
        }
    }

    init() {
        for _ in 1...Constants.cardOnBoard {
            if let card = cardsDeck.showCard() {
                cardsOnTable += [card]
            }
        }
    }
}

extension Array where Element: Equatable {
    mutating func inOut(element: Element) {
        if let from = self.firstIndex(of: element) {
            self.remove(at: from)
        } else {
            self.append(element)
        }
    }
    
    mutating func removeArray(elements: [Element]) {
        self = self.filter {!elements.contains($0)}
    }
}

struct  Constants {
    static let deckCount = 81
    static let cardOnBoard = 12
}

    
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

