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
    @Published private(set) var game: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        // Create Theme
        var themes = [Theme<String>]()
        themes.append(Theme(name: "Food", color: Color.init("FoodColor"), cardContents: ["🍔", "🍦", "🍙", "🍡", "🍭", "🍧", "🍞"]))
        themes.append(Theme(name: "Face", color: Color.init("FaceColor"), cardContents: ["😂", "😊", "😠", "😭", "😄", "😅", "🤔"]))
        themes.append(Theme(name: "Weather", color: Color.gray, cardContents: ["☀️", "🌧️", "🌛", "❄️", "☁️", "🌤", "🌈", "⛈", "🌬", "🌦"]))
        themes.append(Theme(name: "Animal", color: Color.init("AnimalColor"), cardContents: ["🐶", "🐱", "🐹", "🐭", "🦊", "🐰", "🐼", "🐻", "🐻‍❄️", "🐯", "🐨", "🦁", "🙈"]))
        themes.append(Theme(name: "Transport", color: Color.init("TransportColor"), cardContents: ["🚗", "🚕", "🚌", "🚙", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍"]))
        themes.append(Theme(name: "Household", color: Color.init("HouseholdColor"), cardContents: ["📞", "📺", "⏰", "💡", "🛁", "🛋", "🪑", "🛏"]))
        
        let theme = themes[Int.random(in: 0...themes.count-1)]
        
        var emojis: Array<String> = theme.cardContents
        emojis.shuffle()
        
        return MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2...emojis.count), theme: theme) { pairIndex in
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
        game = EmojiMemoryGame.createMemoryGame()
    }
    
}
