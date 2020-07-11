//
//  ContentView.swift
//  MemeMe 1.0
//
//  Created by Will Wang on 2020-07-10.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import AVFoundation
import Photos

struct ContentView: View {
    @EnvironmentObject var meme: MemeModel

    var body: some View {
        NavigationView {
            VStack {
                MemeEditorView()
                ImagePickerView()
            }
            .navigationBarTitle("MemeMe", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    
                }){
                    Image(systemName: "square.and.arrow.up")
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
