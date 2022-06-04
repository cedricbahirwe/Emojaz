//
//  EmojiPreview.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

extension Emoji {
    static var preview: Emoji = Emoji(codes: "1F3CC 1F3FC 200D 2642", char: "🏌🏼‍♂", name: "man golfing: medium-light skin tone", category: "People & Body (person-sport)", group: EmojiGroup.peopleBody, subgroup: "person-sport")
}

extension EmojiSection {
    static var preview: EmojiSection = EmojiSection(key: EmojiGroup.activities, values: [Emoji(codes: "1F383", char: "🎃", name: "jack-o-lantern", category: "Activities (event)", group: EmojiGroup.activities, subgroup: "event"), Emoji(codes: "1F384", char: "🎄", name: "Christmas tree", category: "Activities (event)", group: EmojiGroup.activities, subgroup: "event"), Emoji(codes: "1F386", char: "🎆", name: "fireworks", category: "Activities (event)", group: EmojiGroup.activities, subgroup: "event"), Emoji(codes: "1F387", char: "🎇", name: "sparkler", category: "Activities (event)", group: EmojiGroup.activities, subgroup: "event"), Emoji(codes: "1F9E8", char: "🧨", name: "firecracker", category: "Activities (event)", group: EmojiGroup.activities, subgroup: "event")])
}


extension GridItem {
    static let emojisPreview: [GridItem] = Array(repeating: GridItem(.flexible()),
                                               count: 3)
}
