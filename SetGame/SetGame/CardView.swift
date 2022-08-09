//
//  CardView.swift
//  SetGame
//
//  Created by Kevin Roebuck on 3/29/22.
//

import SwiftUI

struct CardView: View {
    let card: Card
    let aspectRatio: CGFloat
    
    // TODO: Bug: When cards are dealt and then removed (even if we deal cards and click new game!) not all cards that should be displayed are displayed.
    // Something to do with the width not updating?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstant.cornerRadius)
                
                // Determine card color based on card properties
                if let isSet = card.isSet {
                    if isSet {
                        shape.fill().foregroundColor(DrawingConstant.cardSetColor).opacity(DrawingConstant.cardSelectedOpacity)
                    } else {
                        shape.fill().foregroundColor(DrawingConstant.cardNotSetColor).opacity(DrawingConstant.cardSelectedOpacity)
                    }
                } else {
                    if !card.isChosen {
                        shape.fill().foregroundColor(DrawingConstant.cardForegroundColor)
                    } else {
                        shape.fill().foregroundColor(DrawingConstant.cardSelectedColor).opacity(DrawingConstant.cardSelectedOpacity)
                    }
                }

                shape.strokeBorder(lineWidth: DrawingConstant.lineWidth).foregroundColor(DrawingConstant.cardBackgroundColor)
                VStack {
                    ForEach(0..<card.amount, id: \.self) { _ in
                        symbol
                            .foregroundColor(cardColor)
                            .frame(width: geometry.size.width / 2,
                                   height:geometry.size.height / 6)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var symbol: some View {
        switch card.symbol {
            case .diamond:
                switch card.shading {
                    case .open:
                    Circle().stroke(lineWidth: DrawingConstant.symbolLineWidth)
                    case .striped:
                        Circle().opacity(DrawingConstant.stripedOpacity)
                    case .solid:
                        Circle()
                }
            case .rectangle:
                switch card.shading {
                    case .open:
                        Rectangle().stroke(lineWidth: DrawingConstant.symbolLineWidth)
                    case .striped:
                        Rectangle().opacity(DrawingConstant.stripedOpacity)
                    case .solid:
                        Rectangle()
                }
            case .oval:
                switch card.shading {
                    case .open:
                        Diamond().stroke(lineWidth: DrawingConstant.symbolLineWidth)
                    case .striped:
                        Diamond().opacity(DrawingConstant.stripedOpacity)
                    case .solid:
                        Diamond()
                }
        }
    }
    
    private var cardColor: Color {
        switch card.color {
            case .red:
                return .red
            case .green:
                return .green
            case .purple:
                return .purple
        }
    }
    
    private struct DrawingConstant {
        // card
        static let cornerRadius: CGFloat = 10
        static let cardBackgroundColor: Color = .gray
        static let cardForegroundColor: Color = .white
        static let cardSelectedColor: Color = .yellow
        static let cardSetColor: Color = .green
        static let cardNotSetColor: Color = .red
        static let cardSelectedOpacity: CGFloat = 0.2
        static let lineWidth: CGFloat = 3
        
        // symbol
        static let stripedOpacity: CGFloat = 0.25
        static let symbolLineWidth: CGFloat = 3
        static let symbolScale: CGFloat = 0.5
    }
}



































//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
