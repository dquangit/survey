//
//  String+Localization.swift
//  Survey
//
//  Created by Quang Pham on 13/07/2022.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
