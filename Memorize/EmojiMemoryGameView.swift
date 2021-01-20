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
                    withAnimation(.linear(duration: 0.4)) {
                        // `self.` no longer needed here
                        viewModel.choose(card: card)
                    }
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
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewModel.resetGame()
                            }
                        }
                    }
            )
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
    
    @State private var animatedBonusRemaining: Double = 0 // without using this, the pie won't animate
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining // sync w/ model
        // the animation will not happen w/o this
        withAnimation(.linear(duration: card.bonusTimeRemaining)) { // create an animation whose duration equals the time remaining
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90))
                            .onAppear {
                                startBonusTimeAnimation()
                            }
                    }
                    else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90))
                    }
                }.padding(5)
                .opacity(0.4)
                
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 0.5).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
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
