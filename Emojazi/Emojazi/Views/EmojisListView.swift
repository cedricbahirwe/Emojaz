//
//  EmojisListView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojisListView: View {
    @State private var emojis: Emojis = []
    @State private var emojiSections: [EmojiSection] = []
    @AppStorage(EmojaziLocalKeys.showWelcomeView)
    private var showWelcomeView: Bool = true
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible()),
                                            count: 3)
    @State private var nextSection: EmojiGroup = EmojiGroup.allCases[0]

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        ForEach(emojiSections) { section in
                            Section {
                                LazyVGrid(columns: columns) {
                                    ForEach(section.values) { emoji in
                                        NavigationLink(destination: {
                                            EmojiDetailView(emoji: emoji)
                                        }) {
                                            Text(emoji.char)
                                                .font(.system(size: 75))
                                                .foregroundStyle(.secondary)
                                                .padding()
                                                .frame(maxWidth: .infinity)
                                                .background(.thinMaterial)
                                                .cornerRadius(20)
                                                .minimumScaleFactor(0.8)
                                        }
                                    }
                                }
                            } header: {
                                Text(section.key.rawValue.capitalized)
                                    .font(.system(.title, design: .rounded))
                                    .fontWeight(.semibold)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.background)
                            }
                            .id(section.key)
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
            .navigationTitle("Emojazi")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showWelcomeView.toggle()
                    } label: {
                        Label("App Info", systemImage: "info.circle")
                    }

                }
            }
            .onAppear(perform: emojify)

        }
    }

    private func emojify() {
        emojis = decodeJSON(filename: "emoji", as: Emojis.self)
        emojiSections = sectionizeEmojis(emojis)
        print(emojiSections.map { ($0.key, $0.values.count) })
        print(emojiSections.map(\.key))
        print(EmojiGroup.allCases)
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

struct EmojisListView_Previews: PreviewProvider {
    static var previews: some View {
        EmojisListView()
            .preferredColorScheme(.dark)
    }
}
