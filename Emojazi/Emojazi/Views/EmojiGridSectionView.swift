//
//  EmojiGridSectionView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojiGridSectionView: View {
    let columns: [GridItem]
    let section: EmojiSection
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(section.values) { emoji in
                NavigationLink(destination: {
                    EmojiDetailView(emoji: emoji)
                }) {
                    Text(emoji.char)
                        .font(.system(size: 75))
                        .foregroundColor(.accentColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .minimumScaleFactor(0.8)
                }
            }
        }
    }
}

#if DEBUG
struct EmojiGridSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiGridSectionView(columns: GridItem.emojisPreview,
                             section: .preview)
    }
}
#endif
