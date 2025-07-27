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
    @State private var blurred = false

    @State private var angle: Double = 0                // For auto animation
    @State private var dragOffset = CGSize.zero         // For user drag input
    @State private var isDragging = false               // Track drag state
    @State private var timer: Timer?                    // Control auto animation

    let maxRotation: Double = 10

    var dominantColor: Color {
        guard let uiColor = emojiToImage(emoji.char)?.dominantColor() else {
            return Color(uiColor: .label)
        }
        return Color(uiColor: uiColor)
    }

    var body: some View {
        let rotationX = isDragging ? Double(-dragOffset.height / 10).clamped(to: -maxRotation...maxRotation) : sin(angle) * maxRotation
        let rotationY = isDragging ? Double(dragOffset.width / 10).clamped(to: -maxRotation...maxRotation) : cos(angle) * maxRotation


        GeometryReader { geo in
            VStack {
                Text(emoji.char)
                    .foregroundColor(.accentColor)
                    .font(.system(size: 280))
                    .scaleEffect(blurred ? 1 : 1.1)
                    .blur(radius: blurred ? 20 : 0)

                    .overlay(content: {
                        Text(emoji.char)
                            .foregroundColor(.accentColor)
                            .font(.system(size: 260))
                            .blur(radius: blurred ? 0 : 30)
                            .scaleEffect(blurred ? 1 : 0.6)
                    })

                    .rotation3DEffect(.degrees(rotationX), axis: (x: 1, y: 0, z: 0))
                    .rotation3DEffect(.degrees(rotationY), axis: (x: 0, y: 1, z: 0))
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: geo.frame(in: .global).size.height*0.55)
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
//                    .shadow(radius: 10)
                    .overlay(
                        Text("CODE: "+emoji.codes)
                            .foregroundStyle(dominantColor)
                            .fontWeight(.medium)
                            .saturation(6)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                            .padding(10)
                        , alignment: .bottomTrailing
                    )

                Text(emoji.name.capitalized)
                    .font(.system(.title, design: .rounded, weight: .medium))
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
                        .font(.system(.callout, design: .monospaced).weight(.semibold))
                        .foregroundColor(dominantColor)
                        .padding(.vertical, 10)
                        .padding(.horizontal)

                        .background(isEmojiCopied ? Color.green.opacity(0.3): Color.accentColor)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .ignoresSafeArea()
        .onAppear() {
            withAnimation(.easeInOut(duration: 1)) {
                blurred = true
            }

            startTimer()
//            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
//                angle += 0.04
//            }
        }
        .onDisappear() {
            stopTimer()
        }
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
        .font(.system(.headline, design: .rounded))
    }

    private func copyEmojiToClipBoard() {
        UIPasteboard.general.string = emoji.char
        isEmojiCopied = true
    }

    func emojiToImage(_ emoji: String, size: CGFloat = 64) -> UIImage? {
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

extension UIImage {
    func dominantColor() -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }
        let width = 1
        let height = 1

        let bitmapData = calloc(width * height * 4, MemoryLayout<UInt8>.size)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: bitmapData,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: width * 4,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)

        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let data = context?.data else { return nil }
        let ptr = data.bindMemory(to: UInt8.self, capacity: 4)

        let r = CGFloat(ptr[0]) / 255.0
        let g = CGFloat(ptr[1]) / 255.0
        let b = CGFloat(ptr[2]) / 255.0
        let a = CGFloat(ptr[3]) / 255.0

        free(bitmapData)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}


#if DEBUG
struct EmojiDetailView_Previews: PreviewProvider {
    static var previews: some View {
//        EmojiDetailView(emoji: Emoji.preview)
        EmojiDetailView(emoji: EmojiSection.preview.values[0])
            .preferredColorScheme(.dark)
    }
}
#endif


extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
