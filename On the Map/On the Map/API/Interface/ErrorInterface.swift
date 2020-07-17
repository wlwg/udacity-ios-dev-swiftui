//
//  Error.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable, LocalizedError {
    let status: Int
    let error: String
    
    var errorDescription: String? {
        return NSLocalizedString(self.error, comment: "")
    }
}
