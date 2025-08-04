//
//  EmojisListView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojisListView: View {
    let columns: [GridItem]
    var section: EmojiSection

    var body: some View {
        DisclosureGroup {
            EmojiGridSectionView(columns: columns, section: section)
        } label: {
            EmojisSectionHeader(section.key.rawValue, isInGrid: false )
        }
    }
}

#if DEBUG
struct EmojisListView_Previews: PreviewProvider {
    static var previews: some View {
        EmojisListView(columns: GridItem.emojisPreview,
                       section: .preview)
        .previewLayout(.sizeThatFits)
    }
}
#endif
