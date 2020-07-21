//
//  MemeListRow.swift
//  MemeMe 2.0
//
//  Created by Will Wang on 2020-07-12.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

struct MemeListRow: View {
    var meme: MemeModel
    
    var body: some View {
         HStack {
            meme.memedImage!
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .border(Color.gray, width: 1)

            VStack {
                Text(meme.topText.isEmpty ? "TOP" : meme.topText).font(.headline)
                Text(meme.bottomText.isEmpty ? "BOTTOM" : meme.bottomText).font(.headline)
            }
            .frame(width: 150)
        }
        .background(Color.white)
    }
}

struct MemeListRow_Previews: PreviewProvider {
    static var previews: some View {
        MemeListRow(meme: MemeModel(topText: "Top", bottomText: "Bottom", memedImage: Image(systemName: "moon")))
    }
}
