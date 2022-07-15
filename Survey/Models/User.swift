//
//  User.swift
//  Survey
//
//  Created by Quang Pham on 15/07/2022.
//

import Foundation

struct UserResponse: Codable {
    var attributes: User?
}

struct User: Codable {
    var name: String?
    var avatarUrl: String?
    var email: String?
}
