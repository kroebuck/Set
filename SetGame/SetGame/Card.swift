//
//  Card.swift
//  SetGame
//
//  Created by Kevin Roebuck on 3/29/22.
//

import Foundation

struct Card: Codable, Identifiable {
    var isChosen = false
    var isSet: Bool?
    var id: Int
    var symbol: Symbol
    var shading: Shading
    var color: Color
    var amount: Int
    
    enum Symbol: CaseIterable, Codable {
        case diamond
        case rectangle
        case oval
    }
    
    enum Shading: CaseIterable, Codable {
        case open
        case striped
        case solid
    }
    
    enum Color: CaseIterable, Codable {
        case red
        case green
        case purple
    }
}

extension Card {
    enum CodingKeys: String, CodingKey {
        case isChosen = "is_chosen"
        case isSet    = "is_set"
        case id       = "card_id"
        case symbol   = "card_symbol"
        case shading  = "card_shading"
        case color    = "card_color"
        case amount   = "card_amount"
    }
}

extension Card {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isChosen = try values.decode(Bool.self,    forKey: .isChosen)
        isSet    = try values.decode(Bool.self,    forKey: .isSet)
        id       = try values.decode(Int.self,     forKey: .id)
        symbol   = try values.decode(Symbol.self,  forKey: .symbol)
        shading  = try values.decode(Shading.self, forKey: .shading)
        color    = try values.decode(Color.self,   forKey: .color)
        amount   = try values.decode(Int.self,     forKey: .amount)
    }
}
