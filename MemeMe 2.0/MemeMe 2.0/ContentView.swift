//
//  ContentView.swift
//  MemeMe 2.0
//
//  Created by Will Wang on 2020-07-11.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var showEditor: Bool = false
    @State private var meme: MemeModel = MemeModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                TabView {
                    VStack {
                        if appState.memes.count > 0 {
                            MemeListView(onClickMeme: self.editMeme)
                                .padding()
                        } else {
                            Text("No Memes available.")
                        }
                    }.tabItem {
                        Image("table")
                            .scaledToFit()
                    }
                    
                    VStack {
                        if appState.memes.count > 0 {
                            MemeCollectionView(onClickMeme: self.editMeme)
                                .padding()
                        } else {
                            Text("No Memes available.")
                        }
                    }.tabItem {
                        Image("collection")
                            .scaledToFit()
                    }
                }
                    .navigationBarTitle("Sent Memes", displayMode: .inline)
                    .navigationBarItems(trailing:
                        Button(action: {
                            self.meme = MemeModel()
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
                    },
                    onShared: self.addMeme
                )
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration:0.5))
            }
        }
    }
    
    func addMeme() {
        if meme.id == nil {
            meme.id = UUID().uuidString
            appState.memes.append(meme)
            return
        } else {
            appState.memes.removeAll(where: { $0.id == meme.id })
            appState.memes.append(meme)
        }
    }
    
    func editMeme(meme: MemeModel) {
        self.meme = meme
        self.showEditor = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
