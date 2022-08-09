//
//  SetGameModel.swift
//  SetGame
//
//  Created by Kevin Roebuck on 3/29/22.
//

import Foundation

struct SetGameModel {
    private(set) var deck: [Card]
    private(set) var displayedCards: [Card]
    private(set) var isGameFinished: Bool = false
    private(set) var setSelectionCount: (correct: Int, incorrect: Int) = (0, 0)
    private(set) var setAttempted = false
    let startTime = Date()
    
    private var pingCount = 0 // TEMP: NOT FINAL
    
    var chosenCards: [Card] {
        var cards: [Card] = []
        for card in displayedCards {
            if card.isChosen {
                cards.append(card)
            }
        }
        return cards
    }
    
    init() {
        deck = []
        var id = 0
        
        for symbol in Card.Symbol.allCases {
            for shading in Card.Shading.allCases {
                for color in Card.Color.allCases {
                    for amount in 1...3 {
                        deck.append(
                            Card(id: id,
                                 symbol: symbol,
                                 shading: shading,
                                 color: color,
                                 amount: amount
                            )
                        )
                        id += 1
                    }
                }
            }
        }
        deck.shuffle()
        
        displayedCards = []
        for _ in 0..<GameConstant.minDisplayedCardCount {
            displayedCards.append(deck.popLast()!)
        }
    }
    
    func checkIfValidSetFeature<T>(of features: [T]) -> Bool where T: Hashable {
        let duplicates = features.duplicates()
        
        // all elements different
        if duplicates.count == 0{
            return true
        }
        
        // all elements same
        var count = 0
        for feature in features {
            if feature == duplicates[0] {
                count += 1
            }
        }
        if count == features.count {
            return true
        }
        
        // not a set
        return false
    }
    
    func checkIfSet(_ cards: [Card]) -> Bool {
        var symbols: [Card.Symbol] = []
        var shadings: [Card.Shading] = []
        var colors: [Card.Color] = []
        var amounts: [Int] = []
        
        for card in cards {
            symbols.append(card.symbol)
            shadings.append(card.shading)
            colors.append(card.color)
            amounts.append(card.amount)
        }
        
        return checkIfValidSetFeature(of: symbols) && checkIfValidSetFeature(of: shadings) && checkIfValidSetFeature(of: colors) && checkIfValidSetFeature(of: amounts)
    }
    
    // need to have this automatically adjust for changing GameConstant.matchCount
    // hard coding 3 for-loops means it only accounts for a match count of 3
    func howManySetsDisplayed() -> Int {
        var setCount = 0
        
        if displayedCards.count < GameConstant.matchCount {
            print("Not enough cards present to form a set")
            return setCount
        }

        for i in 0..<displayedCards.count-2 {
            for j in i+1..<displayedCards.count-1 {
                for k in j+1..<displayedCards.count {
                    let current = [displayedCards[i], displayedCards[j], displayedCards[k]]
                    if checkIfSet(current) == true {
                        //print(i, j, k)
                        setCount += 1
                    }
                }
            }
        }
        
        //print("Sets: \(setCount)")
        
        return setCount
    }
    
    mutating func choose(_ card: Card) {
        if chosenCards.count < GameConstant.matchCount { // IF NOT TOO MANY CARDS ALREADY CHOSEN
            if let chosenIndex = getCardIndex(of: card) { // IF VALID CARD CHOSEN
                displayedCards[chosenIndex].isChosen.toggle()
                if chosenCards.count == GameConstant.matchCount { // IF SET ATTEMPT
                    setAttempted = true
                    if checkIfSet(chosenCards) { // IF SET
                        setSelectionCount.correct += 1
                        for card in chosenCards {
                            displayedCards[getCardIndex(of: card)!].isSet = true
                        }
                    } else { // IF NOT SET
                        setSelectionCount.incorrect += 1
                        for card in chosenCards {
                            displayedCards[getCardIndex(of: card)!].isSet = false
                        }
                    }
                }
            }
        }
    }
    
    // if set: replace or remove based on displayed card count
    // if not set: unchoose and reset isSet to nil
    mutating func resolveSetAttempt() {
        for card in chosenCards {
            // checking card.isSet here WILL NOT WORK! For some reason, the value of 'isSet' will still be nil
            // even though we just set it to true or false in 'choose()'.
            if displayedCards[getCardIndex(of: card)!].isSet != nil {
                let cardIndex = getCardIndex(of: card)!
                if displayedCards[cardIndex].isSet! {
                    if displayedCards.count > GameConstant.minDisplayedCardCount || deck.count == 0 {
                        displayedCards.remove(at: cardIndex)
                    } else {
                        replaceDisplayedCard(at: cardIndex)
                    }
                } else {
                    displayedCards[cardIndex].isChosen = false
                    displayedCards[cardIndex].isSet = nil
                }
            }
        }
        setAttempted = false
        
        if deck.count == 0 && howManySetsDisplayed() == 0 {
            isGameFinished = true
        }
    }
    
    mutating private func replaceDisplayedCard(at index: Int) {
        if deck.count > 0 {
            displayedCards[index] = deck.popLast()!
        }
    }
    
    mutating func dealCards(amount: Int = GameConstant.dealCardCount) {
        print("Dealing \(min(amount, deck.count)) card(s)...")
        for _ in 0..<min(amount, deck.count) {
            displayedCards.append(deck.popLast()!)
        }
    }
    
    private func getCardIndex(of card: Card) -> Int? {
        for index in displayedCards.indices {
            if displayedCards[index].id == card.id {
                return index
            }
        }
        
        return nil
    }
    
    private struct GameConstant {
        static let minDisplayedCardCount: Int = 12
        static let matchCount: Int = 3
        static let dealCardCount: Int = 3
    }
    
    // TEMP: NOT FINAL
    mutating func ping() {
        pingCount += 1
        print("model ping received")
    }
}

// Implemented to aid checkIfValidSetFeature(_:)
extension Array where Element: Hashable {
    func duplicates() -> Array {
        let groups = Dictionary(grouping: self, by: { $0 })
        let duplicateGroups = groups.filter { $1.count > 1 }
        let duplicates = Array(duplicateGroups.keys)
        return duplicates
    }
}
