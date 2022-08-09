//
//  AspectVGrid.swift
//  SetGame
//
//  Created by Kevin Roebuck on 3/29/22.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView

    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Adding a disabled ScrollView is a hack.
                // Without it, the app would sometimes not display the bottom row of cards when cards had been removed or a new game started.
                // Once the model was updated (even with an arbitrary update of some unrelated value) the last row displayed.
                // No idea why that was occuring, but this fixes it (as far as I can tell...).
                ScrollView() {
                    let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                    LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                        ForEach(items) { item in
                            content(item).aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                    Spacer(minLength: 0)
                }.simultaneousGesture(DragGesture(minimumDistance: 0), including: .all) // disable scrolling without losing card interactability
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount

        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + columnCount - 1) / columnCount
        } while columnCount < itemCount

        if columnCount > itemCount {
            columnCount = itemCount
        }

        return floor(size.width / CGFloat(columnCount))
    }
}
