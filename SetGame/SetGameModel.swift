//
//  File.swift
//  Set: Table Game
//
//  Created by Alexander Ushakov on 23.04.2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import Foundation

class SetGameModel {
    
    private(set) var cardsOnTable = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var cardForMatching = [Card]()
    private(set) var removedCardFromTable = [Card]()

    var hintCards = [Int]()
    
    private var cardsDeck = SetDeck()
    var cardsDeckCount: Int {
        return cardsDeck.cards.count
    }
   
    
    var setDetector: Bool? {
        get {
            guard cardForMatching.count == 3 else {return nil}
            return Card.setMatchDetector(cards: cardForMatching)
        }
        set {
            if newValue != nil {
                cardForMatching = selectedCards
                selectedCards.removeAll()
            } else {
                cardForMatching.removeAll()
            }
        }
    }
    
    var endGameDetector: Bool {
        get {
            guard !checkSetOnTable() && cardsDeckCount == 0 else {return false}
            return true
        }
    }
    
    func choosenCard(index: Int) {
        let choosenCard = cardsOnTable[index]
        if !removedCardFromTable.contains(choosenCard) && !cardForMatching.contains(choosenCard) {
            if selectedCards.count == 2, !selectedCards.contains(choosenCard) {
                selectedCards += [choosenCard]
                setDetector = Card.setMatchDetector(cards: selectedCards)
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
        if !hintCards.isEmpty {
            selectedCards.append(cardsOnTable[hintCards.remove(at: hintCards.count - 1)])
        }
        if selectedCards.count == 3 {
            setDetector = Card.setMatchDetector(cards: selectedCards)
        }
    }
    
    func matchingResult() {
        
        if setDetector != nil {
            if setDetector! {
                for i in cardsOnTable.indices {
                    if cardForMatching.contains(cardsOnTable[i]) {
                        cardsOnTable[i].isFaceUp = false
                    }
                }
            }
        }
    }
    
    private func checkSetOnTable() -> Bool {
        var setDetected = false
            for i in 0..<cardsOnTable.count {
                for j in (i+1)..<cardsOnTable.count {
                    for k in (j+1)..<cardsOnTable.count {
                        let checkingCards = [cardsOnTable[i], cardsOnTable[j], cardsOnTable[k]]
                        if Card.setMatchDetector(cards: checkingCards) {
                            if hintCards.isEmpty {
                               hintCards = [i, j, k]
                            }
                            //print("\(i+1) \(j+1) \(k+1)")
                            setDetected = true
                        }
                    }
                }
            }
        return setDetected
    }
    
    func flipCards() {
        for i in cardsOnTable.indices {
            cardsOnTable[i].isFaceUp = true
        }
    }
        
    func removeCards() {
        if setDetector != nil {
            if setDetector!{
                if !cardsDeck.cards.isEmpty && cardsOnTable.count < 13 {
                    //print("from removeCards: ok < 13")
                    for i in cardsOnTable.indices {
                        if cardsOnTable[i].isFaceUp == false {
                            cardsOnTable.insert(cardsDeck.cards.remove(at: cardsDeck.cards.count.arc4random), at: i)
                            cardsOnTable[i].isFaceUp = false
                            cardsOnTable.remove(at: i + 1)
                        }
                    }
                } else {
                    //print("from removeCards: ok 13")
                    cardsOnTable.removeArray(elements: cardForMatching)
                }
                hintCards.removeAll()
            }
            setDetector = nil
        }
       // print(cardsForAnimation.count)
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
        if let from = self.index(of: element) {
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

    
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

