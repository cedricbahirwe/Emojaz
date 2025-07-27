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

    func getEmoji(_ hexString: String) -> String? {
        guard let codePoint = UInt32(hexString, radix: 16),
              let scalar = UnicodeScalar(codePoint) else {
            return nil
        }
        return String(scalar)
    }

    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(section.values) { emoji in
                NavigationLink(destination: {
                    EmojiDetailView(emoji: emoji)
                }) {
                    Text(emoji.char)
//                    Text(getEmoji(emoji.codes) ?? "-")
                        .font(.system(size: 75))
                        .font(.system(.largeTitle))
                        .foregroundColor(.accentColor)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1, contentMode: .fill)
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
