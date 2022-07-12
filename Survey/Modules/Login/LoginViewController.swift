//
//  LoginViewController.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import UIKit

class LoginViewController: ViewController {
    
    private lazy var backgroundImageView = UIImageView(asset: .loginBackground)
    
    private lazy var logoImageView = UIImageView(asset: .logo)
    
    private lazy var emailField: UITextField = {
        let textField = ValidationTextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = ValidationTextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.snp.makeConstraints { make in
            make.height.equalTo(Dimensions.buttonHeight)
        }
        return button
    }()
    
    override func makeUI() {
        super.makeUI()
        view.addSubviews([
            backgroundImageView,
            logoImageView,
            emailField,
            passwordField,
            loginButton
        ])
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(view).dividedBy(2)
            make.centerX.equalToSuperview()
        }
        passwordField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        emailField.snp.makeConstraints { make in
            make.bottom.equalTo(passwordField.snp.top).offset(-20)
            make.left.right.equalTo(passwordField)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.left.right.equalTo(passwordField)
        }
    }
}
