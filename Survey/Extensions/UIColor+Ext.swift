//
//  UIColor+Ext.swift
//  Survey
//
//  Created by Quang Pham on 18/07/2022.
//

import UIKit

extension UIColor {
    var isLight: Bool {
        guard let components = cgColor.components, components.count > 2 else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return (brightness > 0.5)
    }
}
