//
//  SetGameView.swift
//  SetGame
//
//  Created by Kevin Roebuck on 3/29/22.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject
    var game: SetGameViewModel
    
    var body: some View {
        VStack {
            gameHeader
            gameBody
            gameContinue
            resultsNavigationLink
            gameCurrentStats

            // TEMP: FOR TESTING PURPOSES ONLY
            // Changes an arbitrary model property. Used to redraw SetGameView without changing anything being displayed.
            Button("TESTING ONLY: ping") {
                game.pingModel()
            }
        }
        .navigationBarHidden(true)
    }
    
    // Title, new game button, and deal cards button
    var gameHeader: some View {
        ZStack {
            HStack {
                Button(action: { game.newGame() },
                       label: { Label("New Game", systemImage: "arrow.clockwise") }
                )
                Spacer()
                // TODO: Disable if user clicked this and set was present
                Button(action: { game.dealCards() },
                       label: { Label("Deal Cards", systemImage: "plus.circle") }
                )
                .disabled(game.deck.count == 0)
            }
            .font(.caption)
            .padding(.horizontal)
            Text("SET").font(.title)
        }.padding(.vertical)
    }
    
    // Grid displaying the currently dealt cards
    @ViewBuilder
    var gameBody: some View {
        // An error occurs if 'GameViewConstants.aspectRatio' is directly inserted
        // into AspectVGrid(_:_:_:)
        let aspectRatio = GameViewConstants.aspectRatio
        ZStack {
            Text("Game finished!").opacity(game.isGameFinished ? 1 : 0)
            AspectVGrid(items: game.displayedDeck, aspectRatio: aspectRatio) { card in
                CardView(card: card, aspectRatio: aspectRatio)
                    .padding(2)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
            .disabled(game.isGameFinished)
            .opacity(game.isGameFinished ? 0.3 : 1)
            .padding(.horizontal)
        }
    }
    
    // Button to resolve a set attempt
    var gameContinue: some View {
        Button(action: { game.resolveSetAttempt() },
                label: { Label("continue", systemImage: "arrow.right") }
         )
        .padding(2)
        .disabled(!game.setAttemped && !game.isGameFinished)
        .opacity(game.setAttemped && !game.isGameFinished ? 1 : 0)
    }
    
    // Once game is finished, displays a link to ResultsView
    @ViewBuilder
    var resultsNavigationLink: some View {
        if game.isGameFinished {
            NavigationLink(destination: ResultsView(
                viewModel: ResultsViewModel(
                setSelectionCount: game.setSelectionCount,
                missedSetCount: game.missedSetCount,
                gameStartTime: game.gameStartTime,
                gameEndTime: Date()
                ))
            ) {
                Text("View results")
            }
            .padding(2)
        }
    }
    
    // Correct & incorrect set attempts for current game
    var gameCurrentStats: some View {
        HStack {
            Text("Sets: \(game.setSelectionCount.correct)").padding(.horizontal)
            Text("Incorrect sets: \(game.setSelectionCount.incorrect)").padding(.horizontal)
        }
        .padding(.vertical)
    }
    
    private struct GameViewConstants {
        static let aspectRatio: CGFloat = 1
    }
}










































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(game: game)
    }
}
