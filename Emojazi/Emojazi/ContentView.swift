//
//  ContentView.swift
//  Emojazi
//
//  Created by Cédric Bahirwe on 12/01/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var emojis: Emojis = []
    
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
                                    
    var body: some View {
        
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns,
                          alignment: .leading,
                          pinnedViews: [.sectionHeaders]) {
                    ForEach(emojis) { emoji in
                        VStack {
                            
                            Text(emoji.char)
                                .font(.system(size: 100))
                                .frame(maxWidth: .infinity)

                            Text(emoji.codes)
                                .font(.title)
                                .multilineTextAlignment(.center)
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 180)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .foregroundStyle(.secondary)
                        
                    }
                }
                
                          .padding(.horizontal)
                
            }
            .navigationTitle("Emojazi")
            .onAppear(perform: emojizify)
        }
        
    }
    
    func emojizify() {
        let emojis = decodeJSON(filename: "emoji", as: Emojis.self)
        self.emojis = emojis
        //        print(emojis.count)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
