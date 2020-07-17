//
//  StudentLocation.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}
