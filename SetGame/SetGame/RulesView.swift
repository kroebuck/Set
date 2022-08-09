//
//  RulesView.swift
//  SetGame
//
//  Created by Kevin Roebuck on 3/31/22.
//

import SwiftUI

struct RulesView: View {
    let cards = RuleDemonstrationCards()
    let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        ScrollView {
            VStack {
                Text("The object of the game is to identify a SET of 3 cards from 12 cards displayed. Each card has four features, which can vary as follows:").padding()
                Group {
                    Text("Shapes:")
                    HStack {
                        ForEach(cards.symbols) { card in
                            CardView(card: card, aspectRatio: aspectRatio).frame(minHeight: 100)
                        }
                    }.padding(.horizontal)
                    Text("Colors:")
                    HStack {
                        ForEach(cards.colors) { card in
                            CardView(card: card, aspectRatio: aspectRatio).frame(minHeight: 100)
                        }
                    }.padding(.horizontal)
                    Text("Amounts:")
                    HStack {
                        ForEach(cards.amounts) { card in
                            CardView(card: card, aspectRatio: aspectRatio).frame(minHeight: 100)
                        }
                    }.padding(.horizontal)
                    Text("Shadings:")
                    HStack {
                        ForEach(cards.shadings) { card in
                            CardView(card: card, aspectRatio: aspectRatio).frame(minHeight: 100)
                        }
                    }.padding(.horizontal)
                }
                Text("A SET consists of 3 cards in which each of the cards’ features, looked at one‐by‐one, are the same on each card, or, are different on each card. All of the features must separately satisfy this rule. In other words: shape must be either the same on all 3 cards, or different on each of the 3 cards; color must be either the same on all 3 cards, or different on each of the 3, etc.").padding()
                Group {
                    Text("EXAMPLES:").fontWeight(.bold).padding()
                    Text("SET:")
                    HStack {
                        ForEach(cards.setExample1) { card in
                            CardView(card: card, aspectRatio: aspectRatio).frame(minHeight: 100)
                        }
                    }.padding(.horizontal)
                    Text("SET:")
                    HStack {
                        ForEach(cards.setExample2) { card in
                            CardView(card: card, aspectRatio: aspectRatio).frame(minHeight: 100)
                        }
                    }.padding(.horizontal)
                    Text("SET:")
                    HStack {
                        ForEach(cards.setExample3) { card in
                            CardView(card: card, aspectRatio: aspectRatio).frame(minHeight: 100)
                        }
                    }.padding(.horizontal)
                    Text("Not a SET:")
                    Text("The shadings are not all the same or all different (1 transparent and 2 solid)")
                    HStack {
                        ForEach(cards.notSetExample) { card in
                            CardView(card: card, aspectRatio: aspectRatio).frame(minHeight: 100)
                        }
                    }.padding(.horizontal)
                }
                Spacer(minLength: 10)
            }
        }
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
    }
}
