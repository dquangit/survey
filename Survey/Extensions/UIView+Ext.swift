//
//  UIView+Ext.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import Foundation
import UIKit
import SkeletonView

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
    
    func enableSkeletonAnimation(radius: Float = 0) {
        isSkeletonable = true
        skeletonCornerRadius = radius
    }
    
    func startSkeleton() {
        showAnimatedGradientSkeleton(
            usingGradient: SkeletonGradient(
                colors: [
                    .darkGray,
                    .lightGray,
                    .darkGray
                ]),
            animation: SkeletonAnimationBuilder()
                .makeSlidingAnimation(
                    withDirection: .leftRight
                ),
            transition: .crossDissolve(0.25)
        )
    }
    
    func stopSkeleton() {
        hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
    }
}
