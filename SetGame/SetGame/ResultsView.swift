//
//  ResultsView.swift
//  SetGame
//
//  Created by Kevin Roebuck on 3/31/22.
//

import SwiftUI

struct ResultsView: View {
    let viewModel: ResultsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: geometry.size.height / 10)
                Text("Results").padding()
                Spacer(minLength: geometry.size.height / 10)
                statDisplayView(text: "Sets:", value: String(viewModel.setSelectionCount.correct))
                statDisplayView(text: "Incorrect sets:", value: String(viewModel.setSelectionCount.incorrect))
                statDisplayView(text: "Times set(s) was missed:", value: String(viewModel.missedSetCount))
                statDisplayView(text: "Total game time:", value: viewModel.totalGameTimeText)
                Spacer(minLength: geometry.size.height / 3)
                NavigationLink(destination: SetGameView(game: SetGameViewModel())) {
                    Text("Play again")
                }.padding()
                Spacer(minLength: geometry.size.height / 10)
            }
            .navigationBarHidden(true)
        }
    }
}

struct statDisplayView: View {
    let text: String
    let value: String
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Text(text)
                Spacer()
                Text(String(value))
            }
            .padding(.horizontal, geometry.size.width / 6)
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(viewModel: ResultsViewModel(setSelectionCount: (27, 3),
                                                missedSetCount: 4,
                                                gameStartTime: Date(),
                                                gameEndTime: Date())
                                                )
    }
}
