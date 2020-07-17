//
//  LoginRequest.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct Credential: Codable {
    let username: String
    let password: String
}

struct LoginRequest: Codable {
    let udacity: Credential
    
    init(username: String, password: String) {
        self.udacity = Credential(username: username, password: password)
    }
}


struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct LogoutResponse: Codable {
    let session: Session
}
