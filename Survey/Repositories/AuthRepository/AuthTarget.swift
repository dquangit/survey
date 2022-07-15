//
//  AuthTarget.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation
import Alamofire

enum AuthTarget: TargetType {
    case loginByEmail(email: String, password: String)
    case refreshToken(refreshToken: String)
    case logout(token: String)
    
    var path: String {
        switch self {
        case .loginByEmail:
            return "oauth/token"
        case .refreshToken:
            return "oauth/token"
        case .logout:
            return "oauth/revoke"
        }
    }

    var method: HTTPMethod {
        return .post
    }
    
    var parameters: Parameters? {
        var params = [
            "client_id": Constants.clientId,
            "client_secret": Constants.clientSecret
        ]
        switch self {
        case .loginByEmail(let email, let password):
            params["email"] = email
            params["password"] = password
            params["grant_type"] = "password"
        case .refreshToken(let refreshToken):
            params["grant_type"] = "refresh_token"
            params["refresh_token"] = refreshToken
        case .logout(let token):
            params["token"] = token
        }
        return params
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
