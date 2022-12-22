//
//  ContentView.swift
//  Set
//
//  Created by Christophe Beaulieu on 2022-12-13.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var model: SetGameViewModel
        
    var body: some View {
        NavigationView {
            Group {
                if 0 < model.cards.count { gameView }
                else { endOfGameView }
            }
            .navigationTitle("Cards: \(model.cards.count)/\(model.remainingCards.count)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    resetButton
                }
                ToolbarItem(placement: .primaryAction) {
                    drawCardsButton
                }
            }
        }
    }
    
    @ViewBuilder
    private var gameView: some View {
        AspectVGrid(
            items: Array(model.cards[0..<(model.cards.count)]),
            aspectRatio: 2/3,
            minWidth: CardView.Properties.cardMinWidth) { card in
            let isSelected = model.isSelected(card)
            let cardVariant: CardView.Variant = !isSelected || !model.isCompleteSet
                ? .default
                : model.isValidSet!
                ? .success
                : .error
            CardView(card: card, selected: isSelected, variant: cardVariant)
                .padding(3)
                .onTapGesture { model.choose(card) }
        }
    }
    
    @ViewBuilder
    private var endOfGameView: some View {
        VStack {
            Spacer()
            Group {
                Text("🎉")
                Text("Wow.")
            }
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            Spacer()
            playAgainButton
        }
    }

    @ViewBuilder
    private var resetButton: some View {
        Button {
            model.resetGame()
        } label: {
            Label("Reset game", systemImage: "arrow.counterclockwise")
        }
    }
    
    @ViewBuilder
    private var drawCardsButton: some View {
        Button {
            model.dealMoreCards()
        } label: {
            Label("Add cards", systemImage: "plus")
        }
        .disabled(!model.canDrawCards)
    }
    
    @ViewBuilder
    private var playAgainButton: some View {
        Button {
            model.resetGame()
        } label: {
            HStack {
                Text("Play again")
                Image(systemName: "arrow.counterclockwise")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(model: SetGameViewModel())
    }
}
