//
//  PhotoView.swift
//  Virtual Tourist
//
//  Created by Will Wang on 2020-07-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import CoreData

struct PhotoView: View {
    @State var photo: Photo

    var body: some View {
        Group {
            if photo.image != nil {
                Image(uiImage: UIImage(data: photo.image!)!)
                    .resizable()
                    .scaledToFit()
            } else {
                Rectangle()
                    .background(Color.gray)
            }
        }
        .animation(.easeIn)
    }
}
