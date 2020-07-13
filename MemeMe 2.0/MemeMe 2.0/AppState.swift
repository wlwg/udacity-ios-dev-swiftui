//
//  AppState.swift
//  MemeMe 2.0
//
//  Created by Will Wang on 2020-07-12.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var memes: Array<MemeModel> = []
}
