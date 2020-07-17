//
//  AppState.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import Combine

class AppState: ObservableObject {
    @Published var userInfo: User? = nil
    @Published var studentLocations: [StudentLocation] = []
}
