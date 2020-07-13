//
//  MemeModel.swift
//  MemeMe 2.0
//
//  Created by Will Wang on 2020-07-11.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI


struct MemeModel: Identifiable {
    var id: String? = nil
    var topText: String = ""
    var bottomText: String = ""
    var image: Image? = nil
    var memedImage: Image? = nil
}
