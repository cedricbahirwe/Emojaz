//
//  EmojisHomeView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojisHomeView: View {
    @State private var emojis: Emojis = []
    @State private var emojiSections: [EmojiSection] = []
    @AppStorage(EmojaziLocalKeys.showWelcomeView)
    private var showWelcomeView: Bool = true
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible()),
                                            count: 3)
    @State private var nextSection: EmojiGroup = EmojiGroup.allCases[0]

    @State private var displayMode = DisplayMode.grid

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        

                        ForEach(emojiSections) { section in
                            if displayMode == .list {
                                EmojisListView(columns: columns, section: section)
                            } else {
                                EmojisGridView(columns: columns, section: section)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                if showWelcomeView {
                    Color.clear
                        .background(Color.black.ignoresSafeArea())
                        .opacity(0.5)
                        .onTapGesture {
                            showWelcomeView = false
                        }
                }

                EmojaziWelcomeView()
                    .offset(y: showWelcomeView ? 0 : -800)
                    .animation(.spring(), value: showWelcomeView)
            }
            .onAppear(perform: emojify)
            .navigationTitle("Emojazi")
            .toolbar {

                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: switchDisplayMode) {
                        Label("Diplay Mode", systemImage: displayMode == .list ? "grid.circle" : "list.bullet.rectangle")
                    }
                    Button {
                        showWelcomeView.toggle()
                    } label: {
                        Label("App Info", systemImage: "info.circle")
                    }
                }

            }

        }
    }
    private func emojify() {
        emojis = decodeJSON(filename: "emoji", as: Emojis.self)
        emojiSections = sectionizeEmojis(emojis)
    }

    private func switchDisplayMode() {
        withAnimation {
            displayMode.toggle()
        }
    }

    private func sectionizeEmojis(_ emojis: Emojis) -> [EmojiSection] {
        var sections = [EmojiSection]()
        for group  in EmojiGroup.allCases {
            var section = EmojiSection(key: group, values: [])
            for emoji in emojis {
                if emoji.group == group {
                    section.values.append(emoji)
                }
            }
            sections.append(section)
        }
        return sections
    }

}

struct EmojisHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EmojisHomeView()
    }
}

public enum DisplayMode {
    case list, grid
    mutating func toggle() {
        self = self == .grid ? .list : .grid
    }
}