//
//  ThemeStore.swift
//  Memorize
//
//  Created by Alan Richard on 1/27/21.
//

import SwiftUI
import Foundation
import Combine

class ThemeStore<CardContent: Hashable&Codable>: ObservableObject {
    let defaultColor = ThemeColor.blue
    let untitledThemeName: String = "Untitled"
    
    let name: String
    
    @Published var themes: [Theme<CardContent>]
    
    private var autoSave: AnyCancellable?
    
    init(name: String = "Memorize", themes: [Theme<CardContent>]? = nil) {
        if themes == nil {
            self.themes = [Theme<CardContent>]()
        }
        else {
            self.themes = themes!
        }
        
        self.name = name
        self.autoSave = $themes.sink { names in
            let json = try? JSONEncoder().encode(names)
            UserDefaults.standard.set(json, forKey: "MemorizeStore.\(name)")
            print("! " + (json?.utf8 ?? "nil"))
        }
    }

    func theme(id: UUID) -> Theme<CardContent>? {
        if let matched = themes.first(where: { $0.id == id }) {
            return matched
        }
        else {
            return nil
        }
    }
    
    func theme(_ theme: Theme<CardContent>) -> Theme<CardContent>? {
        self.theme(id: theme.id)
    }
    
    // MARK: - Intents
    
    func addTheme() {
        addTheme(Theme<CardContent>(name: untitledThemeName, color: defaultColor, amountOfPair: 0, cardContents: Array<CardContent>()))
    }
    
    func addTheme(_ theme: Theme<CardContent>) {
        themes.append(theme)
    }
    
    func removeTheme(_ theme: Theme<CardContent>) {
        themes.remove(at: themes.firstIndex(ofId: theme.id)!)
    }
    
    func setName(for theme: Theme<CardContent>, to name: String) {
        themes[themes.firstIndex(matching: theme)!].setName(to: name)
    }
    
    func setColor(for theme: Theme<CardContent>, to color: UIColor.RGB) {
        themes[themes.firstIndex(matching: theme)!].setColor(to: color)
    }
    
    func setAmountOfPair(for theme: Theme<CardContent>, to amount: Int) {
        themes[themes.firstIndex(matching: theme)!].setAmountOfPair(to: amount)
    }
    
    func addCard(for theme: Theme<CardContent>, content: CardContent) {
        themes[themes.firstIndex(matching: theme)!].addCard(content)
    }
    
    func excludeCard(for theme: Theme<CardContent>, card: CardContent) {
        themes[themes.firstIndex(matching: theme)!].excludeCard(card)
    }
    
    func putBackCard(for theme: Theme<CardContent>, card: CardContent) {
        themes[themes.firstIndex(matching: theme)!].putBackCard(card)
    }
}
