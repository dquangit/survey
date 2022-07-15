//
//  Pagination.swift
//  Survey
//
//  Created by Quang Pham on 14/07/2022.
//

import Foundation

struct Pagination: Codable {
    var page: Int?
    var pages: Int?
    var pageSize: Int?
    var records: Int?
    
    var canLoadMore: Bool {
        guard let page = page, let pages = pages else { return false }
        return page < pages
    }
    
    static let defaultPageSize = 5
}
