//
//  EmojisSectionHeader.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojisSectionHeader: View {
    var isIPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    let title: String
    init(_ title: String) {
        self.title = title
    }
    var body: some View {
        Text(title.capitalized)
            .font(.system(.title, design: .rounded))
            .fontWeight(.semibold)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isIPhone ? Color(.systemBackground) : .clear)
    }
}

struct EmojisSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        EmojisSectionHeader("🎉")
    }
}
