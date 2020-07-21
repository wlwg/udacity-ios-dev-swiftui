//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Will Wang on 2020-07-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

enum HTTPMethods: String {
    case GET
    case POST
    case PUT
    case DELETE
}

class FlickrClient {
    static let API_KEY = "3962e4fbac95365c66ea2b777cd47246"

    enum FlickrEndpoint {
        static var BASE: URLComponents {
            var base = URLComponents()
            base.scheme = "https"
            base.host = "api.flickr.com"
            base.path = "/services/rest"
            return base
        }
        
        static let SHARED_QUERY_ITEMS = [
            URLQueryItem(name: "api_key", value: FlickrClient.API_KEY),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        
        enum FlickrMethod: String {
            case PhotoSearch = "flickr.photos.search"
        }

        case PhotoSearch(Double, Double, Int)

        var url: URL {
            switch self {
            case .PhotoSearch(let latitude, let longitude, let limit):
                var urlBuilder = FlickrEndpoint.BASE
                urlBuilder.queryItems = FlickrEndpoint.SHARED_QUERY_ITEMS + [
                    URLQueryItem(name: "method", value: FlickrMethod.PhotoSearch.rawValue),
                    URLQueryItem(name: "lat", value: String(latitude)),
                    URLQueryItem(name: "lon", value: String(longitude)),
                    URLQueryItem(name: "extras", value: "url_s"),
                    URLQueryItem(name: "per_page", value: String(limit))
                ]
                return urlBuilder.url!
            }
        }
    }
    
    func searchPhotos(latitude: Double, longitude: Double, limit: Int = 50, onComplete: @escaping (FlickrPhotoSearchResponse?, Error?)  -> Void) {
        var request = URLRequest(url: FlickrEndpoint.PhotoSearch(latitude, longitude, limit).url)
        request.httpMethod = HTTPMethods.GET.rawValue
        URLSession.shared.dataTask(with: request) {data, response, requestError in
            guard let data = data else {
                DispatchQueue.main.async {
                    onComplete(nil, requestError)
                }
                return
            }

            do {
                let responseData = try JSONDecoder().decode(FlickrPhotoSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    onComplete(responseData, nil)
                }
            } catch {
                do {
                    let errorResponseData = try JSONDecoder().decode(FlickrErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        onComplete(nil, errorResponseData)
                    }
                } catch {
                    print(error) // TODO: log error
                    DispatchQueue.main.async {
                        onComplete(nil, nil)
                    }
                }
            }
        }.resume()
    }
}
