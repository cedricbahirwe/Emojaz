//
//  EmojiDetailView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojiDetailView: View {
    let emoji: Emoji
    @State private var isEmojiCopied = false

    var body: some View {
        GeometryReader { geo in
            VStack {
                Text(emoji.char)
                    .foregroundColor(.accentColor)
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


                Button(action: copyEmojiToClipBoard) {
                    Label("\(isEmojiCopied ? "Copied" : "Copy") Emoji", systemImage: "doc.on.doc")
                        .font(.system(.callout, design: .monospaced).weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(isEmojiCopied ? Color.green: Color.accentColor)
                        .cornerRadius(8)
                }
                .padding()

            }
        }
        .ignoresSafeArea()
    }

    private func hStack(_ key: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(key):")
                .fontWeight(.medium)
            Text(value.capitalized)
        }
        .font(.system(.headline, design: .rounded))
    }

    private func copyEmojiToClipBoard() {
        UIPasteboard.general.string = emoji.char
        isEmojiCopied = true
    }
}

struct EmojiDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiDetailView(emoji: Emoji.preview)
            .preferredColorScheme(.dark)
    }
}
