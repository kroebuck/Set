//
//  ResultsViewModel.swift
//  SetGame
//
//  Created by Kevin Roebuck on 3/31/22.
//

import Foundation

struct ResultsViewModel {
    let setSelectionCount: (correct: Int, incorrect: Int)
    let missedSetCount: Int
    let gameStartTime: Date
    let gameEndTime: Date
    
    var totalGameTimeText: String {
        let timeInterval: Int = Int(gameEndTime.timeIntervalSince(gameStartTime))
        
        let minutes: Int = timeInterval / 60
        let seconds = timeInterval - 60 * minutes
        
        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }
}
