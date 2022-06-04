//
//  Emoji.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 12/01/2022.
//

import Foundation

public typealias Emojis = [Emoji]

// MARK: - Emoji
public struct Emoji: Codable, Identifiable {
    public init(codes: String, char: String, name: String, category: String, group: EmojiGroup, subgroup: String) {
        self.codes = codes
        self.char = char
        self.name = name
        self.category = category
        self.group = group
        self.subgroup = subgroup
    }

    public let codes, char, name, category: String
    public let group: EmojiGroup
    public let subgroup: String
    public var id: String { codes + name }
}

// MARK: - EmojiGroup
public enum EmojiGroup: String, CaseIterable, Codable {
    case activities = "Activities"
    case animalsNature = "Animals & Nature"
    case component = "Component"
    case flags = "Flags"
    case foodDrink = "Food & Drink"
    case objects = "Objects"
    case peopleBody = "People & Body"
    case smileysEmotion = "Smileys & Emotion"
    case symbols = "Symbols"
    case travelPlaces = "Travel & Places"
    
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}


// MARK: - EmojiGroup
public struct EmojiSection: Identifiable {
    public var id: String { key.rawValue }
    public let key: EmojiGroup
    public var values: [Emoji]
}
