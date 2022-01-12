//
//  Emoji.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 12/01/2022.
//

import Foundation

typealias Emojis = [Emoji]

// MARK: - Emoji
struct Emoji: Codable, Identifiable {
    let codes, char, name, category: String
    let group: EmojiGroup
    let subgroup: String
    
    var id: String { codes + name }
}

enum EmojiGroup: String, Codable {
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
}
