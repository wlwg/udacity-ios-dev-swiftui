//
//  MemeCollectionViewCell.swift
//  MemeMe 2.0
//
//  Created by Will Wang on 2020-07-12.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

struct MemeCollectionViewCell: View {
    let image: Image

    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .border(Color.gray, width: 1)
        }
        .background(Color.white)
    }
}


struct MemeCollectionViewCell_Previews: PreviewProvider {
    static var previews: some View {
        MemeCollectionViewCell(image: Image(systemName: "sunset"))
    }
}
