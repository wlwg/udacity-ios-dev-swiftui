//
//  GiphyClient.swift
//  gifu
//
//  Created by Will Wang on 2020-07-21.
//  Copyright © 2020 EezyFun. All rights reserved.
//

import Foundation


enum HTTPMethods: String {
    case GET
    case POST
    case PUT
    case DELETE
}

class GiphyClient {
    static let API_KEY = "qBbWE4YdsJdTkBAVJnpqS9dGhn2YLwE3"

    enum GiphyEndpoint {
        static var BASE: URLComponents {
            var base = URLComponents()
            base.scheme = "https"
            base.host = "api.giphy.com"
            base.path = "/v1/gifs"
            return base
        }
        
        static let SHARED_QUERY_ITEMS = [
            URLQueryItem(name: "api_key", value: GiphyClient.API_KEY),
            //URLQueryItem(name: "limit", value: "2"),
        ]

        case Search(String)
        case Trending

        var url: URL {
            switch self {
            case .Search(let keyword):
                var urlBuilder = GiphyEndpoint.BASE
                urlBuilder.path = "\(urlBuilder.path)/search"
                urlBuilder.queryItems = GiphyEndpoint.SHARED_QUERY_ITEMS + [
                    URLQueryItem(name: "q", value: keyword),
                ]
                return urlBuilder.url!
           
            case .Trending:
                var urlBuilder = GiphyEndpoint.BASE
                urlBuilder.path = "\(urlBuilder.path)/trending"
                urlBuilder.queryItems = GiphyEndpoint.SHARED_QUERY_ITEMS
                return urlBuilder.url!
            }
        }
    }
    
    func search(keyword: String, onComplete: @escaping (Bool, GiphySearchResponse?)  -> Void) {
        self.get(url: GiphyEndpoint.Search(keyword).url, onComplete: onComplete)
    }
    
    func trending(onComplete: @escaping (Bool, GiphySearchResponse?)  -> Void) {
        self.get(url: GiphyEndpoint.Trending.url, onComplete: onComplete)
    }
    
    private func get(
        url: URL,
        onComplete: @escaping (Bool, GiphySearchResponse?)  -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.GET.rawValue
        URLSession.shared.dataTask(with: request) {data, response, requestError in
            guard let data = data else {
                DispatchQueue.main.async {
                    onComplete(false, nil)
                }
                return
            }

            do {
                let responseData = try JSONDecoder().decode(GiphySearchResponse.self, from: data)
                guard responseData.meta.status == 200 else {
                    print(responseData.meta) // TODO: log error
                    DispatchQueue.main.async {
                        onComplete(false, nil)
                    }
                    return
                }
                DispatchQueue.main.async {
                    onComplete(true, responseData)
                }
            } catch {
                do {
                    let errorResponseData = try JSONDecoder().decode(GiphyErrorResponse.self, from: data)
                    print(errorResponseData.message) // TODO: log error
                    DispatchQueue.main.async {
                        onComplete(false, nil)
                    }
                } catch {
                    print(error) // TODO: log error
                    DispatchQueue.main.async {
                        onComplete(false, nil)
                    }
                }
            }
        }.resume()
    }
}

