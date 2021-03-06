//
//  AccessToken.swift
//  Survey
//
//  Created by Quang Pham on 13/07/2022.
//

import Foundation

struct AccessToken: Codable {
    var accessToken: String?
    var tokenType: String?
    var expiresIn: Int?
    var refreshToken: String?
    var createdAt: Date?
}

extension AccessToken {
    
    var authorization: String? {
        guard let token = accessToken,
              let tokenType = tokenType else {
            return nil
        }
        return "\(tokenType) \(token)"
    }
}
