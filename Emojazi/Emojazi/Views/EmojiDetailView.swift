//
//  EmojiDetailView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojiDetailView: View {
    let emoji: Emoji
    let maxRotation: Double = 10

    @State private var isEmojiCopied = false
    @State private var blurred = false
    @State private var angle: Double = 0                // For auto animation
    @State private var dragOffset = CGSize.zero         // For user drag input
    @State private var isDragging = false               // Track drag state
    @State private var timer: Timer?                    // Control auto animation

    @EnvironmentObject private var viewModel: EmojiViewModel
    private let isPad = UIDevice.isPad
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var isPhoneLandscape: Bool {
        !isPad && verticalSizeClass == .compact
    }

    var dominantColor: Color {
        guard let uiColor = emojiToImage(emoji.char)?.dominantColor() else {
            return Color(uiColor: .label)
        }
        return Color(uiColor: uiColor)
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                headerView(geo: geo)
                if isPhoneLandscape {
                    ScrollView {
                        contentView
                    }
                } else  {
                    contentView
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                blurred = true
            } completion: {
                startTimer()
            }
        }
        .onDisappear {
            stopTimer()
        }
    }

    @ViewBuilder
    func headerView(geo: GeometryProxy) -> some View {
        let rotationX = isDragging ? Double(-dragOffset.height / 10).clamped(to: -maxRotation...maxRotation) : sin(angle) * maxRotation
        let rotationY = isDragging ? Double(dragOffset.width / 10).clamped(to: -maxRotation...maxRotation) : cos(angle) * maxRotation

        Text(emoji.char)
            .font(.system(size: isPhoneLandscape ? 180 : 280))
            .scaleEffect(blurred ? 1 : 1.1)
            .blur(radius: blurred ? 20 : 0)
            .overlay {
                Text(emoji.char)
                    .font(.system(size: isPhoneLandscape ? 160 : 260))
                    .blur(radius: blurred ? 0 : 30)
                    .scaleEffect(blurred ? 1 : 0.6)
            }
            .rotation3DEffect(.degrees(rotationX), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(.degrees(rotationY), axis: (x: 0, y: 1, z: 0))
            .frame(maxWidth: .infinity)
            .frame(maxHeight: geo.frame(in: .global).size.height*(isPhoneLandscape ? 0.5 : 0.55))
            .background(Color(.secondarySystemBackground), ignoresSafeAreaEdges: .top)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        stopTimer()
                        dragOffset = value.translation
                        isDragging = true
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            dragOffset = .zero
                            isDragging = false
                        }
                        startTimer()
                    }
            )
            .overlay(
                Text("U+\(emoji.codes)")
                    .font(.system(isPad ? .title : .body, design: .monospaced, weight: .semibold))
                    .foregroundStyle(dominantColor)
                    .saturation(6)
                    .padding(isPad ? 16 : 12)
                    .background(.thinMaterial)
                    .cornerRadius(isPad ? 16 : 8)
                    .padding(isPad ? 16 : 10)
                , alignment: .bottomTrailing
            )
    }

    @ViewBuilder
    var contentView: some View {
        Text(emoji.name.capitalized)
            .font(.system(isPad ? .largeTitle : .title, design: .rounded, weight: .medium))
            .foregroundStyle(dominantColor.gradient)
            .saturation(3)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.75)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)

        VStack(alignment: .leading, spacing: 6) {
            hStack("Category", emoji.category)

            hStack("Group", emoji.group.rawValue)

            hStack("Subgroup", emoji.subgroup)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)


        Button(action: copyEmojiToClipBoard) {
            Label("\(isEmojiCopied ? "Copied" : "Copy") Emoji", systemImage: isEmojiCopied ? "checkmark" : "doc.on.doc")
                .font(.system(isPad ? .title3 : .callout, design: .monospaced).weight(.semibold))
                .foregroundStyle(dominantColor)
                .saturation(6)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(isEmojiCopied ? Color.green.opacity(0.3): Color.accentColor)
                .cornerRadius(8)
        }
        .padding()
        .padding(.top)

    }

    private func  startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            angle += 0.03
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func hStack(_ key: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(key):")
                .fontWeight(.medium)
            Text(value.capitalized)
        }
        .font(.system(isPad ? .title : .body, design: .rounded))

    }

    private func copyEmojiToClipBoard() {
        UIPasteboard.general.string = emoji.char
        isEmojiCopied = true
    }

    private func emojiToImage(_ emoji: String, size: CGFloat = 64) -> UIImage? {
        let label = UILabel()
        label.text = emoji
        label.font = UIFont.systemFont(ofSize: size)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.frame = CGRect(x: 0, y: 0, width: size, height: size)

        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        label.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}


#if DEBUG
#Preview {
    @Previewable @StateObject var viewModel = EmojiViewModel()
    EmojiDetailView(emoji: EmojiSection.preview.values[1])
    //    TestingView(emoji: EmojiSection.preview.values[1])
    //        .environmentObject(viewModel)
    //        .onAppear() {
    //            viewModel.loadData()
    //        }
}
#endif

struct TestingView: View {
    @EnvironmentObject private var viewModel: EmojiViewModel
    let emoji: Emoji
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let item = viewModel.getEmojiNetInfo(for: emoji) {
                if let emojiString = emoji(from: item.unicode) {
                    Text(emojiString)
                        .font(.system(size: 200))
                        .frame(maxWidth: .infinity)
                        .background(.red)

                }

                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Name: \(item.name)")

                        Text("Unicode: U+\(item.unicode)")

                        // Complete all the other properties
                        Text("Definition: \(item.definition)")

                        Text("Category: \(String(describing: item.category))")

                        Text("Keywords: \(item.keywords.joined(separator: ", "))")

                        Text("ShortCode: \(String(describing: item.shortcode))")


                        VStack(alignment: .leading) {
                            Text("Senses: ").font(.title2.bold())
                            if let adjectiveSenses = item.senses.adjectives {
                                makeSenseSection(adjectiveSenses, title: "Adjectives")
                            }

                            if let nounsSenses = item.senses.nouns {
                                makeSenseSection(nounsSenses, title: "Nouns")
                            }

                            if let verbsSenses = item.senses.verbs {
                                makeSenseSection(verbsSenses, title: "Verbs")
                            }
                        }
                    }
                    .padding()
                }
            } else {
                Text("Nothing for \(emoji.codes)")
            }
        }
    }

    @ViewBuilder
    func makeSenseSection(_ items: [SenseItem], title: String) -> some View {
        ForEach(items) { sense in
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3.bold())
                Group {
                    ForEach(sense.definitions, id: \.self) { definition in
                        Text("- " + definition)
                    }

                }
                .padding(.leading, 10)
            }
            .padding(.leading, 8)
        }
    }

    func getEmoji(_ hexString: String) -> String? {
        guard let codePoint = UInt32(hexString, radix: 16),
              let scalar = UnicodeScalar(codePoint) else {
            return nil
        }
        return String(scalar)
    }

    func emoji(from unicodeString: String) -> String? {
        // Step 1: Remove "U+" prefix
        let hexString = unicodeString.replacingOccurrences(of: "U+", with: "")

        // Step 2: Convert to UInt32
        guard let codePoint = UInt32(hexString, radix: 16),
              let scalar = UnicodeScalar(codePoint) else {
            return nil
        }

        // Step 3: Convert to emoji
        return String(scalar)
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
