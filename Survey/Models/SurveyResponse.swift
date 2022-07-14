//
//  SurveyResponse.swift
//  Survey
//
//  Created by Quang Pham on 14/07/2022.
//

import Foundation

struct SurveyResponse: Codable {
    var id: String?
    var type: String?
    var attributes: Survey?
}
