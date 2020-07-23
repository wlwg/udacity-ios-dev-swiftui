//
//  GiphyAPIInterface.swift
//  gifu
//
//  Created by Will Wang on 2020-07-21.
//  Copyright © 2020 EezyFun. All rights reserved.
//

import Foundation


struct GiphyErrorResponse: Codable {
    let message: String
}

struct GifImageResponse: Codable {
    let height: String
    let width: String
    let url: String
}

struct GifImagesResponse: Codable {
    let image: GifImageResponse
    
    enum CodingKeys: String, CodingKey {
        case image = "fixed_width"
    }
}

struct GifResponse: Codable {
    let images: GifImagesResponse
}

struct GiphyStatus: Codable {
    let status: Int
    let msg: String
}

struct GiphySearchResponse: Codable {
    let data: [GifResponse]
    let meta: GiphyStatus
}
