//
//  EmojiDetailView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojiDetailView: View {
    let emoji: Emoji
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text(emoji.char)
                    .font(.system(size: 250))
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: geo.frame(in: .global).size.height*0.55)
                    .background(Color(.secondarySystemBackground), ignoresSafeAreaEdges: .top)
                    .overlay(
                        Text(emoji.codes)
                            .padding(10)
                            .background(.background)
                            .cornerRadius(8)
                            .padding(10)
                        , alignment: .bottomTrailing
                    )

                Text(emoji.name.capitalized)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .foregroundColor(.accentColor.opacity(0.85))
                    .minimumScaleFactor(0.75)

                VStack(alignment: .leading, spacing: 6) {
                    hStack("Category", emoji.category)

                    hStack("Group", emoji.group.rawValue)

                    hStack("Subgroup", emoji.subgroup)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)

            }
        }
        .ignoresSafeArea()
    }

    func hStack(_ key: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(key):")
                .fontWeight(.medium)
            Text(value.capitalized)
        }
        .font(.system(.headline, design: .rounded))
    }
}

struct EmojiDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiDetailView(emoji: Emoji.preview)
    }
}
