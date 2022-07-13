//
//  ValidationTextField.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class ValidationTextField: UITextField {
    
    typealias StringValidator = (String?) -> Bool
    
    private let validator: (String?) -> Bool
    
    private let padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

    init(validator: @escaping StringValidator = {_ in true}) {
        self.validator = validator
        super.init(frame: .zero)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        layer.cornerRadius = 12
        backgroundColor = UIColor.white.withAlphaComponent(0.18)
        textColor = .white
        snp.makeConstraints { make in
            make.height.equalTo(Dimensions.textFieldHeight)
        }
    }
    
    var placeholderColor = UIColor.white.withAlphaComponent(0.3) {
        didSet {
            updatePlaceholder()
        }
    }
    
    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func updatePlaceholder() {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: placeholderColor]
        )
    }
    
    var isValidObservable: Observable<Bool> {
        rx.text.asObservable().map(validator)
    }
}
