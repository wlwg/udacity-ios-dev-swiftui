//
//  StudentLocactionsInterface.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-16.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct PostStudentLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

struct PostStudentLocationResponse: Codable {
    let objectId: String
    let createdAt: String
}

struct GetStudentLocationsResponse: Codable {
    let results: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
