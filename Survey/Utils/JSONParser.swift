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

    static func mapObject<T: Decodable>(
        _ type: T.Type,
        data: Data,
        path: String? = nil
    ) throws -> T {
        return try decoder.decode(T.self, from: getJsonData(data, path: path))
    }
    
    private static func getJsonData(
        _ data: Data,
        path: String? = nil
    ) throws -> Data {
        var jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        if let path = path {
            guard let specificObject = jsonObject.value(forKeyPath: path) else {
                throw ErrorResponse.invalidJson
            }
            jsonObject = specificObject as AnyObject
        }
        if !JSONSerialization.isValidJSONObject(jsonObject) {
            throw ErrorResponse.invalidJson
        }
        return try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        
    }
}

