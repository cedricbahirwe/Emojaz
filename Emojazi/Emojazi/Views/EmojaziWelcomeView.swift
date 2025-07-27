//
//  EmojaziWelcomeView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 04/06/2022.
//

import SwiftUI

struct EmojaziWelcomeView: View {
    @AppStorage(EmojaziLocalKeys.showWelcomeView)
    private var showWelcomeView: Bool = true
    
    var body: some View {
        VStack {
            Text("Welcome to \(Text("**Emojazi**").foregroundStyle(.tint)) ")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.medium)

            Text("Your emoji(s) reference app")
                .font(.system(.headline, design: .rounded))
                .fontWeight(.light)

            VStack(alignment: .leading, spacing: 5) {
                Text("What is a emoji?")
                    .font(.system(.headline, design: .rounded))

                Text("An \(Text("**emoji**").foregroundStyle(.tint)) is a pictogram, logogram or smiley embedded in text and used in electronic messages and web pages. The primary function of emoji is to fill in emotional cues otherwise missing from typed conversation. Some examples of emoji are ❤️, 🌍, 😂, 🧘🏻‍♂️,  🌦️, 🍞, 🚗, 📞, 🎉,  🏁, among many others.)")
                    .textSelection(.enabled)
                    .foregroundStyle(.secondary)
                    .minimumScaleFactor(0.8)

            }
            .padding(.top, 5)
        }
        .padding()
        .frame(width: 310, height: 310)
        .background(.ultraThickMaterial)
        .cornerRadius(30)
    }
}

struct EmojaziWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        EmojaziWelcomeView()
            .preferredColorScheme(.dark)
    }
}
