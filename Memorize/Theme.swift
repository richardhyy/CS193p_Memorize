//
//  Theme.swift
//  Memorize
//
//  Created by Richard on 1/19/21.
//

import Foundation
import SwiftUI

struct Theme<CardContent: Hashable&Codable>: Codable, Hashable, Identifiable {
    static func == (lhs: Theme<CardContent>, rhs: Theme<CardContent>) -> Bool {
        return (lhs.id == rhs.id)// && (lhs.color == rhs.color) && (lhs.amountOfPair == rhs.amountOfPair) && (lhs.cardContents == rhs.cardContents)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        //hasher.combine(color)
        //hasher.combine(amountOfPair)
        //hasher.combine(cardContents)
    }
    
    let id: UUID
    private(set) var name: String
    private(set) var color: UIColor.RGB
    private(set) var amountOfPair: Int
    private(set) var cardContents: [CardContent]
    private(set) var excludedCards = [CardContent]()

    init(id: UUID? = nil, name: String, color: UIColor.RGB, amountOfPair: Int, cardContents: [CardContent]) {
        if id == nil {
            self.id = UUID()
        }
        else {
            self.id = id!
        }
        self.color = color
        self.name = name
        self.amountOfPair = amountOfPair
        self.cardContents = cardContents
    }
    
    init(id: UUID? = nil, name: String, color: String, amountOfPair: Int, cardContents: [CardContent]) {
        self.init(id: id, name: name, color: UIColor.RGB(fromString: color) ?? UIColor.RGB(fromString: ThemeColor.blue.rawValue)!, amountOfPair: amountOfPair, cardContents: cardContents)
    }
    
    init(id: UUID? = nil, name: String, color: ThemeColor, amountOfPair: Int, cardContents: [CardContent]) {
        self.init(id: id, name: name, color: color.rawValue, amountOfPair: amountOfPair, cardContents: cardContents)
    }
    
    mutating func setName(to name: String) {
        self.name = name
    }
    
    mutating func setColor(to color: UIColor.RGB) {
        self.color = color
    }
    
    mutating func setAmountOfPair(to amount: Int) {
        self.amountOfPair = max(0, min(amount, self.cardContents.count/2))
    }
    
    mutating func addCard(_ content: CardContent) {
        cardContents.append(content)
    }
    
    mutating func removeCard(_ content: CardContent) {
        if let index = cardContents.firstIndex(of: content) {
            cardContents.remove(at: index)
        }
    }
    
    mutating func excludeCard(_ content: CardContent) {
        if let index = cardContents.firstIndex(of: content) {
            cardContents.remove(at: index)
            if !excludedCards.contains(content) {
                excludedCards.append(content)
            }
        }
    }
    
    mutating func putBackCard(_ content: CardContent) {
        if let index = excludedCards.firstIndex(of: content) {
            excludedCards.remove(at: index)
            if !cardContents.contains(content) {
                cardContents.append(content)
            }
        }
    }
}

enum ThemeColor: String, CaseIterable {
    case blue = "169,222,249"
    case green = "211,248,226"
    case purple = "228,193,249"
    case red = "246,148,193"
    case black = "10,10,10"
    case orange = "260,202,130"
    case yellow = "237,231,177"
    case gray = "160,160,170"
    
    init?(for color: UIColor.RGB) {
        let cases = ThemeColor.allCases
        if let c = cases.firstIndex(where: { UIColor.RGB(fromString: $0.rawValue ) == color }) {
            self.init(rawValue: cases[c].rawValue)
        }
        else {
            return nil
        }
        //self.init(rawValue: "\(color.red),\(color.green),\(color.blue)")
    }
}
