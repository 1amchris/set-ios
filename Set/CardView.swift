//
//  CardView.swift
//  Set
//
//  Created by Christophe Beaulieu on 2022-12-14.
//

import SwiftUI

struct CardView: View {
    let card: SetGame.Card
    var selected: Bool = false
    var variant: Variant = .default

    var body: some View {
        ZStack {
            if variant != .default {
                RoundedRectangle(cornerRadius: Properties.cardCornerRadius)
                    .strokeBorder(Properties.cardBorderColor[variant]!)
            } else {
                RoundedRectangle(cornerRadius: Properties.cardCornerRadius)
                    .strokeBorder(selected ? HierarchicalShapeStyle.primary : HierarchicalShapeStyle.tertiary)
            }
            
            GeometryReader { geometry in
                VStack {
                    ForEach(1...card.rank.rawValue, id: \.self) { _ in
                        shape.frame(
                            maxWidth: geometry.size.width / 2,
                            maxHeight: geometry.size.height / 4
                        )
                    }
                }
                .position(
                    x: geometry.frame(in: .local).midX,
                    y: geometry.frame(in: .local).midY
                )
            }
            .padding()
        }
        .frame(minWidth: Properties.cardMinWidth, minHeight: Properties.cardMinHeight)
    }
    
    @ViewBuilder
    private var shape: some View {
        let shape = Properties.cardShapes[card.shape]!
        shape
            .opacity(card.shade == .full ? .infinity : .zero)
            .overlay(shape.stroke(lineWidth: Properties.shapeBorderWidth))
            .overlay(card.shade == .striped ? Stripes().clipShape(shape) : nil)
            .foregroundColor(Properties.cardColors[card.color]!)
            .aspectRatio(Properties.shapeAspectRatio, contentMode: .fit)
    }
    
    enum Variant {
        case success, error, `default`
    }

    struct Properties {
        static let cardBorderPadding: CGFloat = 2
        static let cardCornerRadius: CGFloat = 10
        static let cardMinWidth: CGFloat = 75
        static let cardMinHeight: CGFloat = 75
        static let shapeAspectRatio: CGFloat = 2
        static let shapeBorderWidth: CGFloat = 2
        
        static let cardShapes: Dictionary<SetGame.Card.Shape, ShapeWrapper> = [
            .first: ShapeWrapper(Squiggle()),
            .second: ShapeWrapper(Diamond()),
            .third: ShapeWrapper(Pill())
        ]
        static let cardColors: Dictionary<SetGame.Card.Color, Color> = [
            .first: .green,
            .second: .blue,
            .third: .pink
        ]
        static let cardBorderColor: Dictionary<Variant, Color> = [
            .default: .primary,
            .success: .accentColor,
            .error: .red
        ]

    }
}



struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: SetGame.Card(
            color: .first,
            rank: .three,
            shape: .first,
            shade: .striped
            
        ))
    }
}
