//
//  UIView+Ext.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { [weak self] eachView in
            self?.addSubview(eachView)
        }
    }

    func asImage(bounds: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
