//
//  LibsManager.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import Foundation
import IQKeyboardManagerSwift

class LibsManager {
        
    static func setupLibs() {
        setupKeyboardManager()
    }
    
    private static func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
}
