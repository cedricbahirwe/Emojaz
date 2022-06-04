//
//  EmojisGridView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojisGridView: View {
    let columns: [GridItem]
    var section: EmojiSection

    var body: some View {
        Section {
            EmojiGridSectionView(columns: columns, section: section)
        } header: {
            EmojisSectionHeader(section.key.rawValue)
        }
        .id(section.key)
    }
}

#if DEBUG
struct EmojisGridView_Previews: PreviewProvider {
    static var previews: some View {
        EmojisGridView(columns: GridItem.emojisPreview, section: .preview)
    }
}
#endif
