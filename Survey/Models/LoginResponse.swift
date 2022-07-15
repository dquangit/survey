//
//  LoginResponse.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation

struct LoginResponse: Codable {
    var id: String?
    var type: String?
    var attributes: AccessToken?
}
