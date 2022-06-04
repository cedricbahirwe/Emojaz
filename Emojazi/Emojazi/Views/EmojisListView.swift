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
            LazyVGrid(columns: columns) {
                ForEach(section.values) { emoji in
                    NavigationLink(destination: {
                        EmojiDetailView(emoji: emoji)
                    }) {
                        Text(emoji.char)
                            .font(.system(size: 75))
                            .foregroundStyle(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.thinMaterial)
                            .cornerRadius(20)
                            .minimumScaleFactor(0.8)
                    }
                }
            }
        } label: {
            Text(section.key.rawValue.capitalized)
                .font(.system(.title, design: .rounded))
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background)
        }
    }
}

struct EmojisListView_Previews: PreviewProvider {
    static var previews: some View {
        EmojisListView(columns: GridItem.emojisPreview, section: .preview)
            .preferredColorScheme(.dark)
    }
}
