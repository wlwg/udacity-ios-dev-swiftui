//
//  User.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct UserInfo {
    var firstName: String
    var lastName: String
}

struct User {
    var sessionId: String
    var userId: String
    var userInfo: UserInfo?
}
