//
//  SetGameViewModel.swift
//  Set
//
//  Created by Christophe Beaulieu on 2022-12-20.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    
    @Published var game: SetGame
    
    init() {
        self.game = SetGame()
    }
        
    // MARK: -- Computed Properties
    
    var cards: [SetGame.Card] {
        game.displayedCards
    }
    
    var remainingCards: [SetGame.Card] {
        game.displayedCards + game.deck
    }
    
    var canDrawCards: Bool {
        game.deck.count > 0
    }
    
    var isValidSet: Bool? {
        isCompleteSet ? SetGame.CardSet.isValidSet(game.selectedCards) : nil
    }
    
    var isCompleteSet: Bool {
        game.selectedCardIds.count == SetGame.Rules.cardsPerSet
    }
    
    // MARK: -- Functions
    
    func isSelected(_ card: SetGame.Card) -> Bool {
        game.selectedCardIds.contains { $0 == card.id }
    }
    
    // MARK: -- Intents
    
    func choose(_ card: SetGame.Card) {
        game.choose(card)
    }
    
    func dealMoreCards() {
        game.dealMoreCards()
    }
    
    func resetGame() {
        game.reset()
    }
    
}
