//
//  EmojiViewModel.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 27/07/2025.
//

import Foundation
import SwiftUI

@MainActor final class EmojiViewModel: ObservableObject {
    @Published private(set) var emojiSections: [EmojiSection] = []
    @Published private(set) var emojiNet = EmojiNet()
    @Published private(set) var columns: [GridItem] = []

    public func loadData() {
        loadEmojis()
        loadEmojiNet()
    }

    private func loadEmojis() {
        guard emojiSections.isEmpty else { return }

        let columnsCount = UIDevice.current.userInterfaceIdiom == .pad ? 6 : 3
        columns = Array(
            repeating: GridItem(.flexible(), spacing: 8),
            count: columnsCount
        )
        let emojis = decodeJSON(filename: "emoji", as: Emojis.self)
        emojiSections = sectionizeEmojis(emojis)
    }

    private func loadEmojiNet(){
//        let startDate = Date()
//        print("starting at \(startDate)")
//        let emojis = decodeJSON(filename: "emojis", as: [EmojiNetItem].self)
//        let endDate = Date()
//        emojiNet = EmojiNet(emojis)
//        print("finished at \(endDate), elapsed time: \(endDate.timeIntervalSince(startDate)) seconds")
    }

    private func sectionizeEmojis(_ emojis: Emojis) -> [EmojiSection] {
        EmojiGroup.allCases.map { group in
            let groupEmojis = emojis.filter { $0.group == group }
            return EmojiSection(key: group, values: groupEmojis)
        }
    }


    func getEmojiNetInfo(for emoji: Emoji) -> EmojiNetItem? {
        emojiNet.itemByUnicode(emoji.codes)
    }
}
