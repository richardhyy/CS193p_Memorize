//
//  ThemeStoreView.swift
//  Memorize
//
//  Created by Alan Richard on 1/27/21.
//

import SwiftUI
import Combine

struct ThemeStoreView: View {
    @ObservedObject var store: ThemeStore<String>
    
    @State private var editMode: EditMode = .inactive
    
    private var autoUpdateEditorShowingIndicator: AnyCancellable?
    
    init(store: ThemeStore<String>) {
        self.store = store
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(theme: theme)) {
                        ThemeEntryView(store: store, theme: theme, editMode: $editMode)
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { store.themes[$0] }.forEach { theme in
                        store.removeTheme(theme)
                    }
                }
            }
            .navigationTitle(store.name)
            .navigationBarItems(
                leading: Button(action: {
                                            store.addTheme()
                                        },
                                label: {
                                            Image(systemName: "plus").imageScale(.large)
                                        }),
                trailing: EditButton()
            ).environment(\.editMode, $editMode)
        }
    }
}

struct ThemeEntryView: View {
    @ObservedObject var store: ThemeStore<String>
    let theme: Theme<String>
    @Binding var editMode: EditMode
    @State var isShowingEditor = false
    
    @State private var themeName: String = ""
    @State private var contents = [String]()
    
    var body: some View {
        HStack {
            if editMode.isEditing {
                Image(systemName: "pencil.circle.fill")
                    .onTapGesture {
                        isShowingEditor = true
                    }
                    .popover(isPresented: $isShowingEditor, content: {
                        ThemeEditor(store: store, theme: theme, isShowing: $isShowingEditor)
                    })
                    .foregroundColor(.blue)
                    .imageScale(.large)
            }
            VStack {
                EditableText(theme.name, isEditing: editMode.isEditing) { newName in
                    store.setName(for: theme, to: newName)
                }
                    .foregroundColor(Color((theme.color)))
                
                HStack {
                    Text(getSampleView(for: theme)).font(.footnote)
                    Spacer()
                }
            }
        }
    }
    
    func getSampleView(for theme: Theme<String>) -> String {
        var sampleCardText = ""
        
        if theme.cardContents.count > 0 {
            let upperBoundSampleIndex = min(5, theme.cardContents.count)
            for index in 0..<upperBoundSampleIndex {
                sampleCardText += theme.cardContents[index]
            }
            
            if upperBoundSampleIndex < theme.cardContents.count {
                sampleCardText += " and \(theme.cardContents.count - upperBoundSampleIndex) more"
            }
        }
        else {
            sampleCardText = "No cards"
        }
        
        return sampleCardText
    }
}

struct ThemeEditor: View {
    @ObservedObject var store: ThemeStore<String>
    
    let theme: Theme<String>
    
    @Binding var isShowing: Bool
    
    @State private var themeName: String = ""
    @State private var contentToAdd: String = ""
    @State private var color = ThemeColor.blue
    @State private var amountOfPair = "0"
    
    var body: some View {
        return VStack {
            ZStack {
                Text("Edit: \(themeName)")
                HStack {
                    Spacer()
                    Button(action: {
                        isShowing = false
                    }, label: { Text("Done") }).padding()
                }
            }
            Divider()
            Form {
                Section {
                    TextField("New Name", text: $themeName, onEditingChanged: { began in
                        if !began {
                            store.setName(for: theme, to: themeName)
                        }
                    })
                    TextField("Emoji to Add", text: $contentToAdd, onCommit: {
                        for index in contentToAdd.indices {
                            let char = contentToAdd[index]
                            if char != " " {
                                store.addCard(for: theme, content: (String(char)))
                            }
                        }
                        contentToAdd = ""
                    })
                }
                Section(header: Text("Amount Of Pair")) {
                    TextField("Amount Of Pair", text: $amountOfPair, onCommit : {
                        store.setAmountOfPair(for: theme, to: Int(amountOfPair) ?? 0)
                    })
                }
                Section(header: Text("Cards")) {
                    if store.theme(theme)!.cardContents.count == 0 {
                        Text("No card").font(Font.system(.footnote))
                    }
                    else {
                        Text("Tap to exclude")
                        Grid(store.theme(theme)!.cardContents, id: \.self) { card in
                            Text(card)
                                .font(Font.system(size: fontSize))
                                .onTapGesture {
                                    store.excludeCard(for: theme, card: card)
                                }
                        }
                        .frame(height: getFrameHeight(elementCount: theme.cardContents.count, elementWidth: emojiBoxWidth))
                    }
                }
                Section(header: Text("Excluded Cards")) {
                    if store.theme(theme)!.excludedCards.count == 0 {
                        Text("No card").font(Font.system(.footnote))
                    }
                    else {
                        Text("Tap to put back")
                        Grid(store.theme(theme)!.excludedCards, id: \.self) { card in
                            Text(card)
                                .font(Font.system(size: fontSize))
                                .onTapGesture {
                                    withAnimation(Animation.linear(duration: animationDuration)) {
                                        store.putBackCard(for: theme, card: card)
                                    }
                                }
                        }
                        .frame(height: getFrameHeight(elementCount: theme.cardContents.count, elementWidth: emojiBoxWidth))
                    }
                }
                Section(header: Text("Theme Color")) {
                    Grid(ThemeColor.allCases, id: \.rawValue) { color in
                        ZStack {
                            if ThemeColor(for: UIColor(store.theme(theme)!.color).rgb) ?? ThemeColor.blue == color {
                                RoundedRectangle(cornerRadius: colorSampleBoxCornorRadius)
                                    .size(CGSize(width: colorSampleBoxWidth, height: colorSampleBoxWidth))
                                    .stroke(lineWidth: 3.0)
                                    .foregroundColor(.accentColor)
                            }
                            RoundedRectangle(cornerRadius: colorSampleBoxCornorRadius)
                                .size(CGSize(width: colorSampleBoxWidth, height: colorSampleBoxWidth))
                                .foregroundColor(Color(UIColor.RGB(fromString: color.rawValue)!))
                                .onTapGesture {
                                    withAnimation(Animation.linear(duration: animationDuration)) {
                                        //self.color = color
                                        store.setColor(for: theme, to: UIColor.RGB(fromString: color.rawValue)!)
                                    }
                                }
                            }
                    }
                    .frame(height: getFrameHeight(elementCount: ThemeColor.allCases.count, elementWidth: colorSampleBoxWidth + 10))
                    .padding()
                }
            }
        }
        .onAppear {
            let thm: Theme<String>! = store.theme(theme)!
            themeName = thm.name
            color = ThemeColor(for: thm.color) ?? ThemeColor.blue
            amountOfPair = String(thm.amountOfPair)
        }
    }
    
    // MARK: - Drawing constants
    let animationDuration: Double = 0.3
    let fontSize: CGFloat = 36
    let emojiBoxWidth: CGFloat = 70
    let colorSampleBoxCornorRadius: CGFloat = 5
    let colorSampleBoxWidth: CGFloat = 56
    
    private func getFrameHeight(elementCount: Int, elementWidth: CGFloat) -> CGFloat {
        return CGFloat((elementCount - 1) / 6) * elementWidth + elementWidth
    }
    
    /*enum AlertType {
        case RemoveEmoji(String)
        case AddEmoji(String)
    }*/
}
