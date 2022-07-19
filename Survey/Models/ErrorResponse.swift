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
    case noInternetConnection
    case unknown
    case invalidJson

    var localizedDescription: String {
        switch self {
        case .badRequest:
            return "bad_request".localized
        case .unauthorized:
            return "unauthorized".localized
        case .forbidden:
            return "forbidden".localized
        case .notFound:
            return "not_found".localized
        case .unknown, .invalidJson:
            return "technical_issue".localized
        case .noInternetConnection:
            return "no_internet_connection".localized
        }
    }
}
