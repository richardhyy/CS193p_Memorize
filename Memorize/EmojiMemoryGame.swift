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
    @Published private(set) var game: MemoryGame<String> = EmojiMemoryGame.createMemoryGame() {
        didSet {
            print(game.json?.utf8 ?? "nil")
        }
    }
    
    static func createMemoryGame() -> MemoryGame<String> {
        // Create Theme
        var themes = [Theme<String>]()
        themes.append(Theme(name: "Food", color: UIColor(Color.init("FoodColor")).rgb, amountOfPair: 4, cardContents: ["🍔", "🍦", "🍙", "🍡", "🍭", "🍧", "🍞"]))
        themes.append(Theme(name: "Face", color: UIColor(Color.init("FaceColor")).rgb, amountOfPair: 4, cardContents: ["😂", "😊", "😠", "😭", "😄", "😅", "🤔"]))
        themes.append(Theme(name: "Weather", color: UIColor.gray.rgb, amountOfPair: 5, cardContents: ["☀️", "🌧️", "🌛", "❄️", "☁️", "🌤", "🌈", "⛈", "🌬", "🌦"]))
        themes.append(Theme(name: "Animal", color: UIColor(Color.init("AnimalColor")).rgb, amountOfPair: 5, cardContents: ["🐶", "🐱", "🐹", "🐭", "🦊", "🐰", "🐼", "🐻", "🐻‍❄️", "🐯", "🐨", "🦁", "🙈"]))
        themes.append(Theme(name: "Transport", color: UIColor(Color.init("TransportColor")).rgb, amountOfPair: 4, cardContents: ["🚗", "🚕", "🚌", "🚙", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍"]))
        themes.append(Theme(name: "Household", color: UIColor(Color.init("HouseholdColor")).rgb, amountOfPair: 5, cardContents: ["📞", "📺", "⏰", "💡", "🛁", "🛋", "🪑", "🛏"]))
        
        let theme = themes[Int.random(in: 0...themes.count-1)]
        
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
        game = EmojiMemoryGame.createMemoryGame()
    }
    
}
