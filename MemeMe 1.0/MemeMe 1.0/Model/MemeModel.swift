//
//  Meme.swift
//  MemeMe 1.0
//
//  Created by Will Wang on 2020-07-10.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

class MemeModel: ObservableObject {
    @Published var topText: String = ""
    @Published var bottomText: String = ""
    @Published var image: Image?
    @Published var memedImage: UIImage? // Use UIImage type only because sharing using UIActivityViewController requires such type.
}
