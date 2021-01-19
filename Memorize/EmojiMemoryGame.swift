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
    // outsiders can only `get` & cannot `set`
    @Published private var game: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        var emojis: Array<String> = ["🐶", "🤔", "🐘", "🎃", "😂", "🌈", "🍔", "🏫", "☔️"]
        emojis.shuffle()
        
        return MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2...5)) { pairIndex in
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
}
