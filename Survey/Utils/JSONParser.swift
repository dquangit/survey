//
//  JSONParser.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation

class JSONParser {

    private static let decoder: JSONDecoder = {
       let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    private static let encoder: JSONEncoder = {
       let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }()

    static func encodableToData<T: Encodable>(_ object: T) -> Data? {
        return try? encoder.encode(object)
    }

    static func mapObject<T: Decodable>(_ type: T.Type, data: Data) throws -> T {
        return try decoder.decode(T.self, from: data)
    }

    static func mapArray<T: Decodable>(_ type: T.Type, data: Data) throws -> [T] {
        return try decoder.decode([T].self, from: data)
    }
}

