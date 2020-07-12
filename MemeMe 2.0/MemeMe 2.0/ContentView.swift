//
//  ContentView.swift
//  MemeMe 2.0
//
//  Created by Will Wang on 2020-07-11.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showEditor: Bool = false
    @State private var meme: MemeModel = MemeModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                Text("Hello, World!")
                    .navigationBarTitle("Sent Memes", displayMode: .inline)
                    .navigationBarItems(trailing:
                        Button(action: {
                            self.showEditor = true
                        }) {
                            Image(systemName: "plus")
                        }
                    )
            }
            if showEditor {
                MemeEditorView(
                    meme: self.$meme,
                    onDismiss: {
                        self.showEditor = false
                    }
                )
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration:0.5))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
