//
//  DateUtils.swift
//  Survey
//
//  Created by Quang Pham on 14/07/2022.
//

import Foundation

class DateUtils {
    
    private static let dateInWeekFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        return dateFormatter
    }()
    
    static func dateInWeek(_ date: Date) -> String? {
        return dateInWeekFormatter.string(from: date)
    }
}
