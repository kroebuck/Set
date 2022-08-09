//
//  WelcomeView.swift
//  SetGame
//
//  Created by Kevin Roebuck on 3/31/22.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var game = SetGameViewModel()
    var body: some View {
        NavigationView {
            VStack {
                Text("SET")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                NavigationLink(destination: SetGameView(game: game)) {
                    Text("Start game")
                }
                    .font(.title)
                    .padding()
                NavigationLink(destination: RulesView()) {
                    Text("How to play")
                }
                    .font(.title)
                    .padding()
                Spacer()
                // Multipeer
                HStack {
                    Button("Advertise") {
                        game.advertise()
                    }
                    Button("Invite") {
                        game.invite()
                    }
                }.padding()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
