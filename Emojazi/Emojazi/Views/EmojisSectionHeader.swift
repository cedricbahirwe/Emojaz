//
//  EmojisSectionHeader.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojisSectionHeader: View {
    var isPhone: Bool { !UIDevice.isPad }
    let title: String
    let isInGrid: Bool

    init(_ title: String, isInGrid: Bool) {
        self.title = title
        self.isInGrid = isInGrid
    }

    var body: some View {
        Text(title.capitalized)
            .font(.system(.title, design: .monospaced, weight: .semibold))
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isInGrid ? Color(.quaternarySystemFill) : .clear)
            .foregroundStyle(.blue.gradient)
    }
}

struct EmojisSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        EmojisSectionHeader("🎉 This is fun", isInGrid: true)
    }
}
