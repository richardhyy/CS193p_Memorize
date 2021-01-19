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
    
    func body(for size: CGSize) -> some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                Text(card.content)
            }
            else if !card.isMatched {
                RoundedRectangle(cornerRadius: cornerRadius).fill()
            }
        }
        //.aspectRatio(0.66, contentMode: .fit)
        .font(Font.system(size: fontSize(for: size)))
    }
    
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
            .preferredColorScheme(.light)
    }
}
