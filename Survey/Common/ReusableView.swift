//
//  ReusableView.swift
//  Survey
//
//  Created by Quang Pham on 14/07/2022.
//

import Foundation

import UIKit

protocol ReusableCell {
    static var identifier: String { get }
}

extension ReusableCell where Self: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

