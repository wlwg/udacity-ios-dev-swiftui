//
//  FlickrAPIInterface.swift
//  Virtual Tourist
//
//  Created by Will Wang on 2020-07-19.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


struct FlickrErrorResponse: Codable, LocalizedError {
    let stat: String
    let code: Int
    let message: String
    
    var errorDescription: String? {
        return NSLocalizedString(self.message, comment: "")
    }
}

struct FlickrPhoto: Codable {
    let url: String
    let width: Int16
    let height: Int16
    
    enum CodingKeys: String, CodingKey {
        case url = "url_s"
        case width = "width_s"
        case height = "height_s"
    }
}

struct FlickrPhotoPage: Codable {
    let photo: [FlickrPhoto]
}

struct FlickrPhotoSearchResponse: Codable {
    let photos: FlickrPhotoPage
    let stat: String
}
