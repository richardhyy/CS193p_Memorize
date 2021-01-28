//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Richard on 1/19/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    static let storeName = "Memorize"
    
    let store: ThemeStore<String>
    
    init() {
        let data = UserDefaults.standard.data(forKey: "MemorizeStore.\(MemorizeApp.storeName)")
        do {
            if data != nil {
                let themes:[Theme<String>]? = try JSONDecoder().decode([Theme<String>].self, from: data!)
                self.store = ThemeStore(name: MemorizeApp.storeName, themes: themes!)
            }
            else {
                self.store = ThemeStore(name: MemorizeApp.storeName)
                MemorizeApp.addDefaultThemes(for: self.store)
            }
        } catch {
            self.store = ThemeStore(name: MemorizeApp.storeName)
            MemorizeApp.addDefaultThemes(for: self.store)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            //let game = EmojiMemoryGame()
            //EmojiMemoryGameView(viewModel: game)
            ThemeStoreView(store: store)
        }
    }
    
    static func addDefaultThemes(for store: ThemeStore<String>) {
        store.addTheme(Theme(name: "Food", color: ThemeColor.orange, amountOfPair: 4, cardContents: ["🍔", "🍦", "🍙", "🍡", "🍭", "🍧", "🍞"]))
        store.addTheme(Theme(name: "Face", color: ThemeColor.yellow, amountOfPair: 4, cardContents: ["😂", "😊", "😠", "😭", "😄", "😅", "🤔"]))
        store.addTheme(Theme(name: "Weather", color: ThemeColor.gray, amountOfPair: 5, cardContents: ["☀️", "🌧️", "🌛", "❄️", "☁️", "🌤", "🌈", "⛈", "🌬", "🌦"]))
        store.addTheme(Theme(name: "Animal", color: ThemeColor.green, amountOfPair: 5, cardContents: ["🐶", "🐱", "🐹", "🐭", "🦊", "🐰", "🐼", "🐻", "🐻‍❄️", "🐯", "🐨", "🦁", "🙈"]))
        store.addTheme(Theme(name: "Transport", color: ThemeColor.purple, amountOfPair: 4, cardContents: ["🚗", "🚕", "🚌", "🚙", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍"]))
        store.addTheme(Theme(name: "Household", color: ThemeColor.red, amountOfPair: 5, cardContents: ["📞", "📺", "⏰", "💡", "🛁", "🛋", "🪑", "🛏"]))
    }
}
