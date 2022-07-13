//
//  ErrorResponse.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation

enum ErrorResponse: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case unknown
    case invalidJson

    var localizedDescription: String {
        switch self {
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not Found"
        case .unknown, .invalidJson:
            return "Technical issue"
        }
    }
}
