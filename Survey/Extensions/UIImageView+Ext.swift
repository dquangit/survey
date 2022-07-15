//
//  UIImageView+Ext.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import Foundation
import UIKit

extension UIImageView {
    convenience init(asset: ImageAsset) {
        self.init(image: UIImage(asset: asset))
    }
}
