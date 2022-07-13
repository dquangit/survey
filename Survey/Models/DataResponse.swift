//
//  DataResponse.swift
//  Survey
//
//  Created by Quang Pham on 13/07/2022.
//

import Foundation

struct DataResponse<T: Decodable>: Decodable {
    var data: T
}
