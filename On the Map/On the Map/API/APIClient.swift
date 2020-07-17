//
//  APIClient.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class APIClient {
    enum HTTPMethods: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let authEndpoint = "\(Endpoints.base)/session"
        static let usersEndpoint = "\(Endpoints.base)/users"
        static let studentLocationEndpoint = "\(Endpoints.base)/StudentLocation"

        case auth
        case user(String)
        case getStudentLocations(Int?)
        case postStudentLocation
        
        var value: String {
            switch self {
                case .auth:
                    return Endpoints.authEndpoint
                case .user(let userId):
                    return "\(Endpoints.usersEndpoint)/\(userId)"
                case .getStudentLocations(let limit):
                    if let limit = limit {
                        return "\(Endpoints.studentLocationEndpoint)?limit=\(limit)"
                    }
                    return Endpoints.studentLocationEndpoint
                case .postStudentLocation:
                    return Endpoints.studentLocationEndpoint
            }
        }

        var url: URL {
            return URL(string: value)!
        }
        
    }
    
    static func login(username: String, password: String, completionHandler: @escaping (User?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.auth.url)
        request.httpMethod = HTTPMethods.POST.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(username: username, password: password)
        request.httpBody = try! JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: request) {data, response, taskError in
            guard var data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
                return
            }

            data = data.subdata(in: 5..<data.count)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    print(error)  // TODO: change to log
                    DispatchQueue.main.async {
                        completionHandler(nil, taskError)
                    }
                }
                return
            }

            do {
                let responseData = try JSONDecoder().decode(LoginResponse.self, from: data)
                let user = User(sessionId: responseData.session.id, userId: responseData.account.key)
                DispatchQueue.main.async {
                    completionHandler(user, nil)
                }
            } catch {
                print(error)  // TODO: change to log
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
            }
        }.resume()
    }

    static func logout(sessionId: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.auth.url)
        request.httpMethod = HTTPMethods.DELETE.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(sessionId, forHTTPHeaderField: "X-XSRF-TOKEN")
        URLSession.shared.dataTask(with: request) {data, response, taskError in
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                guard var data = data else {
                    DispatchQueue.main.async {
                        completionHandler(false, taskError)
                    }
                    return
                }

                data = data.subdata(in: 5..<data.count)
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(false, errorResponse)
                    }
                } catch {
                    print(error)  // TODO: change to log
                    DispatchQueue.main.async {
                        completionHandler(false, taskError)
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(true, nil)
            }
        }.resume()
    }
    
    static func getUserInfo(userId: String, completionHandler: @escaping (UserInfo?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.user(userId).url)
        request.httpMethod = HTTPMethods.GET.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) {data, response, taskError in
            guard var data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
                return
            }

            data = data.subdata(in: 5..<data.count)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    print(error)  // TODO: change to log
                    DispatchQueue.main.async {
                        completionHandler(nil, taskError)
                    }
                }
                return
            }

            do {
                let responseData = try JSONDecoder().decode(GetUserResponse.self, from: data)
                let userInfo = UserInfo(firstName: responseData.firstName, lastName: responseData.lastName)
                DispatchQueue.main.async {
                    completionHandler(userInfo, nil)
                }
            } catch {
                print(error)  // TODO: change to log
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
            }
        }.resume()
    }
    
    static func getStudentLocations(limit: Int?, completionHandler: @escaping ([StudentLocation]?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getStudentLocations(limit).url)
        request.httpMethod = HTTPMethods.GET.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) {data, response, taskError in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
                return
            }

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    print(error)  // TODO: change to log
                    DispatchQueue.main.async {
                        completionHandler(nil, taskError)
                    }
                }
                return
            }

            do {
                let responseData = try JSONDecoder().decode(GetStudentLocationsResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseData.results, nil)
                }
            } catch {
                print(error)  // TODO: change to log
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
            }
        }.resume()
    }
    
    static func saveStudentLocation(
        uniqueKey: String,
        firstName: String,
        lastName: String,
        mapString: String,
        mediaURL: String,
        latitude: Double,
        longitude: Double,
        completionHandler: @escaping (StudentLocation?, Error?) -> Void
    ) {
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = HTTPMethods.POST.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = PostStudentLocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        request.httpBody = try! JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: request) {data, response, taskError in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
                return
            }

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    print(error)  // TODO: change to log
                    DispatchQueue.main.async {
                        completionHandler(nil, taskError)
                    }
                }
                return
            }

            do {
                let responseData = try JSONDecoder().decode(PostStudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(StudentLocation(objectId: responseData.objectId, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, createdAt: responseData.createdAt, updatedAt: responseData.createdAt), nil)
                }
            } catch {
                print(error)  // TODO: change to log
                DispatchQueue.main.async {
                    completionHandler(nil, taskError)
                }
            }
        }.resume()
    }
}
