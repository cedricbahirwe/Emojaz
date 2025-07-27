//
//  EmojiNet.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 27/07/2025.
//

import Foundation

struct EmojiNet {
    let values: [EmojiNetItem]
    init(_ values: [EmojiNetItem] = []) {
        self.values = values
    }
}

extension EmojiNet: Collection {
    // MARK: - Collection conformance

    var startIndex: Int {
        values.startIndex
    }

    var endIndex: Int {
        values.endIndex
    }

    func index(after i: Int) -> Int {
        values.index(after: i)
    }

    subscript(position: Int) -> EmojiNetItem {
        values[position]
    }
}

struct EmojiNetItem: Codable {
    let name: String
    let unicode: String
    let definition: String
    let category: String?
    let keywords: [String]
    let shortcode: String?
    let senses: Senses
}

struct Senses: Codable {
    let adjectives: [SenseItem]?
    let verbs: [SenseItem]?
    let nouns: [SenseItem]?
}

struct SenseItem: Codable {
    let id: String
    let definitions: [String]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dict = try container.decode([String: [String]].self)

        guard let first = dict.first else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Empty sense item")
        }

        self.id = first.key
        self.definitions = first.value
    }
}
