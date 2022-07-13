//
//  LoginViewModelSpecs.swift
//  SurveyTests
//
//  Created by Quang Pham on 13/07/2022.
//

import Quick
import Nimble
import Swinject
import Cuckoo
import RxSwift
import RxCocoa
@testable import Survey

class LoginViewModelSpecs: QuickSpec {
    override func spec() {

        var email: BehaviorSubject<String>!
        var password: BehaviorSubject<String>!
        var onButtonTap: PublishSubject<Void>!
        var container: Container!
        var input: LoginViewModel.Input!
        var viewModel: LoginViewModel!
        var output: LoginViewModel.Output!
        var disposeBag: DisposeBag!
        var loginButtonEnabled: Bool?
        var loginSuccess: Bool?
        var loginError: Error?
        
        describe("LoginViewModel") {
            
            beforeEach {
                email = BehaviorSubject<String>(value: "")
                password = BehaviorSubject<String>(value: "")
                onButtonTap = PublishSubject<Void>()
                container = self.setupContainer()
                input = LoginViewModel.Input(
                    email: email.asDriverOnErrorJustComplete(),
                    password: password.asDriverOnErrorJustComplete(),
                    onLoginTap: onButtonTap.asDriverOnErrorJustComplete()
                )
                viewModel = LoginViewModel(resolver: container)
                output = viewModel.transform(input: input)
                disposeBag = DisposeBag()
    
                output.loginButtonEnabled.drive(onNext: { enabled in
                    loginButtonEnabled = enabled
                }).disposed(by: disposeBag)
                output.loginSuccess.drive(onNext: {
                    loginSuccess = true
                }).disposed(by: disposeBag)
                viewModel.error.drive(onNext: { error in
                    loginError = error
                }).disposed(by: disposeBag)
            }
            
            afterEach {
                viewModel = nil
                disposeBag = nil
                loginButtonEnabled = nil
                loginSuccess = nil
                loginError = nil
            }
            
            context("validate email and password") {
                
                it("empty email - expected login button disabled") {
                    email.onNext("")
                    password.onNext("not an empty string")
                    expect(loginButtonEnabled).to(beFalse())
                }
                
                it("invalid email - expected login button disabled") {
                    email.onNext("this is an invalid email")
                    password.onNext("not an empty string")
                    expect(loginButtonEnabled).to(beFalse())
                }
                
                it("empty password - expected login button disabled") {
                    email.onNext("correct@email.com")
                    password.onNext("")
                    expect(loginButtonEnabled).to(beFalse())
                }
                
                it("valid email and password - expected login button enabled") {
                    email.onNext("correct@email.com")
                    password.onNext("correctPassword")
                    expect(loginButtonEnabled).to(beTrue())
                }
            }
            
            context("login with invalid credentials") {
                
                it("expected error") {
                    email.onNext("wrong@email.com")
                    password.onNext("wrongPassword")
                    onButtonTap.onNext(())
                    expect(loginError).notTo(beNil())                }
            }
            
            context("login with valid credentials") {
                
                it("expected login successful") {
                    email.onNext("correct@email.com")
                    password.onNext("correctPassword")
                    onButtonTap.onNext(())
                    expect(loginSuccess).to(beTrue())
                }
            }
        }
    }
    
    private func setupContainer() -> Container {
        let mockAuthRepository = MockAuthRepository()
        stub(mockAuthRepository) { stub in
            when(
                stub.loginByEmail(
                    email: "correct@email.com",
                    password: "correctPassword"
                )
            )
            .thenReturn(Single.just(LoginResponse()))
            
            when(
                stub.loginByEmail(
                    email: "wrong@email.com",
                    password: "wrongPassword"
                )
            )
            .thenReturn(Single<LoginResponse>.error(ErrorResponse.badRequest))
        }
        let container = Container()
        container.register(AuthRepository.self) { r in
            mockAuthRepository
        }
        return container
    }
}
