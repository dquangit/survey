//
//  TargetType.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation
import Alamofire

public protocol TargetType {

    var baseUrl: String { get }

    var path: String { get }

    var method: HTTPMethod  { get }

    var headers: [String: String] { get }
        
    var parameters: Parameters? { get }
    
    var parameterEncoding: ParameterEncoding { get }
    
}

extension TargetType {

    var baseUrl: String {
        Constants.baseUrl
    }

    var headers: [String: String] {
        [:]
    }
}
