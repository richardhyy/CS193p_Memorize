//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Richard on 1/19/21.
//

// ViewModel

import SwiftUI

// ObservableObject can only be applied to classes!

class EmojiMemoryGame: ObservableObject {
    @Published var theme: Theme<String>
    
    // outsiders can only `get` & cannot `set`
    @Published private(set) var game: MemoryGame<String> {
        didSet {
            print(game.json?.utf8 ?? "nil")
        }
    }
    
    init(theme: Theme<String>) {
        self.theme = theme
        self.game = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    static func createMemoryGame(theme: Theme<String>) -> MemoryGame<String> {
        var emojis: Array<String> = theme.cardContents
        emojis.shuffle()
        
        return MemoryGame<String>(numberOfPairsOfCards: theme.amountOfPair, theme: theme) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card> {
        return game.cards
    }
    
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        game.choose(card: card)
    }
    
    func resetGame() {
        game = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
}
