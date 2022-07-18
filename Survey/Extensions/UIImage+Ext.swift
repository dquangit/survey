//
//  UIImage+Ext.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(asset: ImageAsset) {
        self.init(named: asset.rawValue)
    }
}
