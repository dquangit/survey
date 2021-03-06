//
//  Survey.swift
//  Survey
//
//  Created by Quang Pham on 14/07/2022.
//

import Foundation

struct Survey: Codable {
    var title: String?
    var description: String?
    var coverImageUrl: String?
    
    var highResolutionCoverImageUrl: String? {
        guard let coverImageUrl = coverImageUrl else {
            return nil
        }
        return "\(coverImageUrl)l"
    }
}
