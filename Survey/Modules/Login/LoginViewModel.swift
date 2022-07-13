//
//  LoginViewModel.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let email: Driver<String>
        let password: Driver<String>
        let onLoginTap: Driver<Void>
    }
    
    struct Output {
        let loginButtonEnabled: Driver<Bool>
        let loginSuccess: Driver<Void>
    }
    
    private let tokenSaved = PublishSubject<Void>()
    
    func transform(input: Input) -> Output {
        let params = Observable.combineLatest(
            input.email.asObservable(),
            input.password.asObservable()
        )
        
        input
            .onLoginTap
            .asObservable()
            .withLatestFrom(params)
            .subscribe(onNext: { [weak self] (email, password) in
                self?.login(email: email, password: password)
            }).disposed(by: rx.disposeBag)
        
        let loginButtonEnabled = params.map { (email, password) in
            return Validator.isValidEmail(email) && Validator.isValidPassword(password)
        }.asDriverOnErrorJustComplete()
        
        return Output(
            loginButtonEnabled: loginButtonEnabled,
            loginSuccess: tokenSaved.asDriverOnErrorJustComplete()
        )
    }
    
    private func login(email: String, password: String)  {
        resolver.resolve(AuthRepository.self)!
            .loginByEmail(email: email, password: password)
            .trackActivity(loading)
            .catch{ error in
                if let error = error as? ErrorResponse,
                   error == ErrorResponse.badRequest {
                    throw AppError(message: "login_failed".localized)
                }
                throw error
            }
            .trackError(error)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.resolver.resolve(AccessTokenProvider.self)?.updateToken(token: response.attributes)
                self.tokenSaved.onNext(())
            })
            .disposed(by: rx.disposeBag)
    }
}
