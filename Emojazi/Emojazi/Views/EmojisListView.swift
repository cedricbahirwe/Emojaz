//
//  EmojisListView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojisListView: View {
    @State private var emojis: Emojis = []
    @AppStorage(EmojaziLocalKeys.showWelcomeView)
    private var showWelcomeView: Bool = true

    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, pinnedViews: [.sectionHeaders]) {
                        ForEach(emojis) { emoji in
                            NavigationLink(destination: {
                                EmojiDetailView(emoji: emoji)
                            }) {
                                VStack {
                                    Text(emoji.char)
                                        .font(.system(size: 100))
                                        .frame(maxWidth: .infinity)

                                    Text(emoji.codes)
                                        .font(.title)
                                        .multilineTextAlignment(.center)

                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 180)
                                .background(.thinMaterial)
                                .cornerRadius(20)
                                .foregroundStyle(.secondary)
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
    }
}

struct EmojisListView_Previews: PreviewProvider {
    static var previews: some View {
        EmojisListView()
//                    .preferredColorScheme(.dark)
    }
}
