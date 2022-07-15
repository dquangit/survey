//
//  UserTarget.swift
//  Survey
//
//  Created by Quang Pham on 15/07/2022.
//

import Foundation
import Alamofire

enum UserTarget: TargetType {
    
    case getUserProfile
    
    var path: String {
        switch self {
        case .getUserProfile:
            return "me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserProfile:
            return .get
        }
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var authorizationRequired: Bool {
        return true
    }
}
