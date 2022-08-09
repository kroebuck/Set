//
//  RuleDemonstrationCards.swift
//  SetGame
//
//  Created by Kevin Roebuck on 3/31/22.
//

import Foundation
import SwiftUI

struct RuleDemonstrationCards {
    var id: Int = -1
    var symbols: [Card] = []
    var shadings: [Card] = []
    var colors: [Card] = []
    var amounts: [Card] = []
    
    var setExample1: [Card] = []
    var setExample2: [Card] = []
    var setExample3: [Card] = []
    var notSetExample: [Card] = []
    
    init() {
        // Symbols
        for symbol in Card.Symbol.allCases {
            let card = Card(id: id, symbol: symbol, shading: .solid, color: .red, amount: 1)
            symbols.append(card)
            id -= 1
        }
        
        // Shadings
        for shading in Card.Shading.allCases {
            let card = Card(id: id, symbol: .oval, shading: shading, color: .green, amount: 3)
            shadings.append(card)
            id -= 1
        }
        
        // Colors
        for color in Card.Color.allCases {
            let card = Card(id: id, symbol: .diamond, shading: .solid, color: color, amount: 1)
            colors.append(card)
            id -= 1
        }
        
        // Amounts
        for amount in 1...3 {
            let card = Card(id: id, symbol: .rectangle, shading: .solid, color: .purple, amount: amount)
            amounts.append(card)
            id -= 1
        }
        
        // Set Example 1
        for shading in Card.Shading.allCases {
            let card = Card(id: id, symbol: .oval, shading: shading, color: .red, amount: 2)
            setExample1.append(card)
            id -= 1
        }
        
        // Set Example 2
        setExample2.append(Card(id: id, symbol: .rectangle, shading: .striped, color: .green, amount: 1))
        id -= 1
        setExample2.append(Card(id: id, symbol: .oval, shading: .striped, color: .purple, amount: 2))
        id -= 1
        setExample2.append(Card(id: id, symbol: .diamond, shading: .striped, color: .red, amount: 3))
        id -= 1
        
        // Set Example 3
        setExample3.append(Card(id: id, symbol: .oval, shading: .striped, color: .purple, amount: 1))
        id -= 1
        setExample3.append(Card(id: id, symbol: .diamond, shading: .solid, color: .green, amount: 2))
        id -= 1
        setExample3.append(Card(id: id, symbol: .rectangle, shading: .open, color: .red, amount: 3))
        id -= 1
        
        // Not Set Example
        notSetExample.append(Card(id: id, symbol: .rectangle, shading: .striped, color: .red, amount: 1))
        id -= 1
        notSetExample.append(Card(id: id, symbol: .rectangle, shading: .solid, color: .red, amount: 2))
        id -= 1
        notSetExample.append(Card(id: id, symbol: .rectangle, shading: .solid, color: .red, amount: 3))
        id -= 1
    }
}
