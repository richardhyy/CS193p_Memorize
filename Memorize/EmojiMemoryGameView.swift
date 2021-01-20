//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Richard on 1/19/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        NavigationView {
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    // `self.` no longer needed here
                    viewModel.choose(card: card)
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(viewModel.game.theme.color)
            .navigationBarTitle(viewModel.game.theme.name, displayMode: .inline)
            .navigationBarItems(leading:
                HStack {
                    Text("Score: \(viewModel.game.score)")
                },
                trailing:
                    HStack {
                        Button("New Game") {
                            viewModel.game = EmojiMemoryGame.createMemoryGame()
                    }
            })
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90)).padding(5) // TODO: Animation
                    .opacity(0.4)
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
        // it's a ViewBuilder so we don't have to use else or Group{} here to make every condition return
    }
    
    // MARK: - Drawing Constants
    
    private let fontScaleFactor: CGFloat = 0.65
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
