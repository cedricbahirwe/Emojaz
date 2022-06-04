//
//  EmojisHomeView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojisHomeView: View {
    @State private var emojiSections: [EmojiSection] = []
    @AppStorage(EmojaziLocalKeys.showWelcomeView)
    private var showWelcomeView: Bool = true
    @State private var columns: [GridItem] = []
    @State private var nextSection: EmojiGroup = EmojiGroup.allCases[0]
    @State private var displayMode = DisplayMode.grid

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    if displayMode == .list {
                        VStack {
                            ForEach(emojiSections) { section in
                                EmojisListView(columns: columns, section: section)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        LazyVStack(pinnedViews: [.sectionHeaders]) {
                            ForEach(emojiSections) { section in
                                EmojisGridView(columns: columns, section: section)
                            }
                        }
                        .padding(.horizontal)
                    }
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
                    .opacity(showWelcomeView ? 1 : 0)
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
        .navigationViewStyle(StackNavigationViewStyle())
    }


    private func emojify() {
        guard emojiSections.isEmpty else { return }
        if UIDevice.current.userInterfaceIdiom == .pad {
            columns = Array(repeating: GridItem(.flexible()),
                            count: 6)
        } else {
            columns = Array(repeating: GridItem(.flexible()),
                                                    count: 3)
        }
        let emojis = decodeJSON(filename: "emoji", as: Emojis.self)
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
