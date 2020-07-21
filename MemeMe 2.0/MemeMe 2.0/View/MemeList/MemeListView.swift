//
//  MemeListView.swift
//  MemeMe 2.0
//
//  Created by Will Wang on 2020-07-12.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

struct MemeListView: View {
    @EnvironmentObject var appState: AppState
    
    let onClickMeme: (MemeModel) -> Void
    
    var body: some View {
        List(appState.memes, id: \.id) { meme in
            MemeListRow(meme: meme)
                .onTapGesture {
                    self.onClickMeme(meme)
            }
        }
    }
}

struct MemeListView_Previews: PreviewProvider {
    static var previews: some View {
        MemeListView(onClickMeme: {meme in
            print(meme)
        })
    }
}
