//
//  EmojisHomeView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojisHomeView: View {
    @StateObject private var viewModel: EmojiHomeViewModel = .init()
    @AppStorage(EmojaziLocalKeys.showWelcomeView)
    private var showWelcomeView: Bool = true
    @State private var nextSection: EmojiGroup = EmojiGroup.allCases[0]
    @State private var displayMode = DisplayMode.grid

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    if displayMode == .list {
                        VStack {
                            ForEach(viewModel.emojiSections) { section in
                                EmojisListView(columns: viewModel.columns, section: section)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        LazyVStack(pinnedViews: [.sectionHeaders]) {
                            ForEach(viewModel.emojiSections) { section in
                                EmojisGridView(columns: viewModel.columns, section: section)
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
                    .offset(y: showWelcomeView ? -50 : -800)
                    .opacity(showWelcomeView ? 1 : 0)
                    .animation(.spring(), value: showWelcomeView)
            }
            .onAppear(perform: viewModel.loadData)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(
                "Emojazi \(viewModel.emojiSections.map(\.values).flatMap({ $0 }).count) and \(viewModel.emojiNet.count)"
            )
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

    private func switchDisplayMode() {
        withAnimation {
            displayMode.toggle()
        }
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
