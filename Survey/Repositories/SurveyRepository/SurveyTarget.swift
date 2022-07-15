//
//  SurveyTarget.swift
//  Survey
//
//  Created by Quang Pham on 14/07/2022.
//

import Foundation
import Alamofire

enum SurveyTarget: TargetType  {
    
    case getSurverList(page: Int, size: Int)
    
    var path: String {
        switch self {
        case .getSurverList:
            return "surveys"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getSurverList:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getSurverList(let page, let size):
            return [
                "page": [
                    "number": page,
                    "size": size
                ]
            ]
        }
    }
    
    var authorizationRequired: Bool {
        switch self {
        case .getSurverList:
            return true
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }
}
