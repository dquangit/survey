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
        let textField = ValidationTextField(validator: Validator.isValidEmail)
        textField.placeholder = "email".localized
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.alpha = 0
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = ValidationTextField()
        textField.placeholder = "password".localized
        textField.isSecureTextEntry = true
        textField.alpha = 0
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setTitle("login".localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.setTitleColor(.lightGray, for: .disabled)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.snp.makeConstraints { make in
            make.height.equalTo(Dimensions.buttonHeight)
        }
        button.alpha = 0
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
            make.center.equalToSuperview()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.logoImageView.snp.remakeConstraints { make in
                    make.centerY.equalToSuperview().dividedBy(2)
                    make.centerX.equalToSuperview()
                }
                self.view.layoutIfNeeded()
                self.emailField.alpha = 1
                self.passwordField.alpha = 1
                self.loginButton.alpha = 1
            }
        )
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? LoginViewModel else {
            return
        }
        let input = LoginViewModel.Input(
            email: emailField.rx.text.orEmpty.asDriver(),
            password: passwordField.rx.text.orEmpty.asDriver(),
            onLoginTap: loginButton.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
        output
            .loginButtonEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)

        output.loginSuccess.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.setViewControllers(
                [self.resolver.resolve(SurveyListViewController.self)!],
                animated: false
            )
        }).disposed(by: rx.disposeBag)
    }
    
    override func onError(error: Error) {
        guard let error = error as? ErrorResponse else {
            return super.onError(error: error)
        }
        switch error {
        case .badRequest:
            showAlert(title: "login_failed".localized, message: "invalid_email_or_password".localized)
        default:
            return super.onError(error: error)
        }
    }
}
