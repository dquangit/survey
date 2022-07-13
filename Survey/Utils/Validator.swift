//
//  Validator.swift
//  Survey
//
//  Created by Quang Pham on 13/07/2022.
//

import Foundation

class Validator {
    
    private static let emailPredicate = NSPredicate(
        format:"SELF MATCHES %@",
        "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    )
    
    static func isValidEmail(_ string: String?) -> Bool {
        guard let string = string else {
            return false
        }
        return emailPredicate.evaluate(with: string)
    }
    
    static func isValidPassword(_ string: String?) -> Bool {
        guard let string = string else {
            return false
        }
        return !string.isEmpty
    }
}
