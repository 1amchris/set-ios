//
//  SetGame.swift
//  Set
//
//  Created by Christophe Beaulieu on 2022-12-13.
//

import Foundation

struct SetGame {
    
    // Gameplay
    //  1.  init
    //  2.  toggle cards
    //  3.  if 3 cards toggled, validate set
    //  3a.     if set is valid
    //  3ai.        replace cards on next click, or '+', if enough cards are in the deck
    //  3aii.       select card if toggled card is existing card
    //  3aiii.      go to 2.
    //  3b.     if set is invalid
    //  3bi.        select card on click
    //  3bii.       go to 2.
    //  4.  End of game.
    
    private(set) var deck: [Card]
    private(set) var displayedCards: [Card]
    private(set) var selectedCardIds: Set<UUID>
    private(set) var matches: [CardSet]
    
    init() {
        var generatedDeck = SetGame.generateDeck()

        displayedCards = (0..<Rules.startingCardsCount).map { _ in generatedDeck.popLast()! }
        deck = generatedDeck
        matches = []
        selectedCardIds = []
    }

    // MARK: -- Computed Properties
    
    var selectedCards: [Card] {
        selectedCardIds.map { id in displayedCards.first { card in card.id == id }! }
    }
    
    // MARK: -- Actions
    
    mutating func choose(_ card: Card) {
        if selectedCardIds.count == Rules.cardsPerSet {
            if CardSet.isValidSet(selectedCards) {
                try! matches.append(CardSet(with: selectedCards))
                try! replaceSelectedCards(with: drawCards(count: min(Rules.cardsPerSet, UInt(deck.count))))
            } else {
                selectedCardIds = []
            }
        }
        
        if displayedCards.contains(card) {
            selectedCardIds = selectedCardIds.symmetricDifference([card.id])
        }
    }

    mutating func dealMoreCards() {
        guard Rules.cardsPerSet <= deck.count else { return }
        
        if selectedCards.count == Rules.cardsPerSet, CardSet.isValidSet(selectedCards) {
            try! replaceSelectedCards(with: drawCards(count: Rules.cardsPerSet))
        } else {
            displayedCards.insert(contentsOf: drawCards(count: Rules.cardsPerSet), at: displayedCards.endIndex)
        }
    }
    
    mutating func reset() {
        deck = SetGame.generateDeck()
        displayedCards = drawCards(count: Rules.startingCardsCount)
        matches = []
        selectedCardIds = []
    }

    mutating private func drawCards(count: UInt) -> [Card] {
        return (0..<count).map { _ in deck.popLast()! }
    }
    
    mutating private func replaceSelectedCards(with cards: [Card]) throws {
        guard cards.count <= selectedCardIds.count else {
            throw SetError.invalidNumberOfCards(received: UInt(cards.count), expected: UInt(selectedCardIds.count))
        }
        
        let selectedIndices = displayedCards
            .enumerated()
            .filter { (_, card) in selectedCardIds.contains { $0 == card.id } }
            .map { (index, _) in index }
        
        for (index, selectedIndex) in selectedIndices.sorted(by: >).enumerated() {
            displayedCards.remove(at: selectedIndex)
            if index < cards.count {
                displayedCards.insert(cards[index], at: selectedIndex)
            }
        }
        
        selectedCardIds = []
    }

    // MARK: -- Generator functions
    
    static private func generateDeck(shuffled: Bool = true) -> [Card] {
        var deck: [Card] = []
        for color in Card.Color.allCases {
            for rank in Card.Rank.allCases {
                for shape in Card.Shape.allCases {
                    for shade in Card.Shade.allCases {
                        deck.append(Card(color: color, rank: rank, shape: shape, shade: shade))
                    }
                }
            }
        }
        return shuffled ? deck.shuffled() : deck
    }
    
    // MARK: -- Game Objects/Rules/Errors
    
    struct Rules {
        static let cardsPerSet: UInt = 3
        static let startingCardsCount: UInt = 12
    }
    
    private enum SetError: Error {
        case invalidNumberOfCards(received: UInt, expected: UInt = Rules.cardsPerSet)
        case invalidSetOfCards(received: [Card])
    }
    
    struct Card: Identifiable, Hashable {
        
        var id: UUID
        
        let color: Color
        let rank: Rank
        let shape: Shape
        let shade: Shade
        
        init(color: `Color`, rank: Rank, shape: `Shape`, shade: Shade) {
            self.id = UUID()
            
            self.color = color
            self.rank = rank
            self.shape = shape
            self.shade = shade
        }
        
        enum Color: CaseIterable {
            case first, second, third
        }

        enum Rank: Int, CaseIterable {
            case one = 1, two, three
        }
        
        enum Shade: CaseIterable {
            case full, striped, transparent
        }

        enum Shape: CaseIterable {
            case first, second, third
        }
    }
    
    struct CardSet: Hashable {
        let cards: Set<Card>
        
        init(with cards: [Card]) throws {
            guard cards.count == Rules.cardsPerSet else {
                throw SetError.invalidNumberOfCards(received: UInt(cards.count), expected: Rules.cardsPerSet)
            }
            
            guard CardSet.isValidSet(cards) else {
                throw SetError.invalidSetOfCards(received: cards)
            }
            
            self.cards = Set(cards)
        }
                

        static private func countProperty<PropertyType>(in cards: [Card], getProperty: (Card) -> PropertyType) -> UInt where PropertyType: Hashable {
            UInt(
                cards
                    .reduce(into: Dictionary<PropertyType, UInt>()) { acc, card in
                        let property = getProperty(card)
                        acc[property] = (acc[property] ?? 0) + 1
                    }
                    .keys
                    .count
            )
        }

        
        static func isValidSet(_ cards: [Card]) -> Bool {
            // check that color is valid
            let colorCount = CardSet.countProperty(in: cards) { $0.color }
            if 1 < colorCount && colorCount < Rules.cardsPerSet {
                return false
            }
            
            // check that rank is valid
            let rankCount = CardSet.countProperty(in: cards) { $0.rank }
            if 1 < rankCount && rankCount < Rules.cardsPerSet {
                return false
            }

            // check that shape is valid
            let shapeCount = CardSet.countProperty(in: cards) { $0.shape }
            if 1 < shapeCount && shapeCount < Rules.cardsPerSet {
                return false
            }

            // check that shade is valid
            let shadeCount = CardSet.countProperty(in: cards) { $0.shade }
            if 1 < shadeCount && shadeCount < Rules.cardsPerSet {
                return false
            }

            return true
        }
    }
}
