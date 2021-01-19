//
//  MemoryGame.swift
//  Memorize
//
//  Created by Richard on 1/19/21.
//

// Model

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: [Card]
    var theme: Theme<CardContent>
    var score: Int = 0
    var hasSeen = [CardContent]()
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.only
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, theme: Theme<CardContent>, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
        self.theme = theme
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                }
                else if (hasSeen.contains(cards[chosenIndex].content)) {
                    score -= 1
                } else {
                    hasSeen.append(cards[chosenIndex].content)
                }
                self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp
            }
            else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        
        var id: Int
    }
}
