//
//  AlertContent.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct AlertContent: Identifiable {
    let id: String = UUID().uuidString

    let title: String
    let message: String
}
