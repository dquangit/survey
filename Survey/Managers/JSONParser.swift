//
//  JSONParser.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation

class JSONParser {

    private static let _decoder = JSONDecoder()

    static func mapObject<T: Decodable>(_ type: T.Type, data: Data) throws -> T {
        return try _decoder.decode(T.self, from: data)
    }

    static func mapArray<T: Decodable>(_ type: T.Type, data: Data) throws -> [T] {
        return try _decoder.decode([T].self, from: data)
    }
}

