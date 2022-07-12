//
//  AuthRepositoryImpl.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation
import RxSwift

class AuthRepositoryImpl: AuthRepository {
    
    private let restApi: RestApi
    
    init(resApi: RestApi) {
        self.restApi = resApi
    }
    
    func loginByEmail(email: String, password: String) -> Single<LoginResponse> {
        restApi.request(
            AuthTarget.loginByEmail(
                email: email,
                password: password
            )
        )
    }
    
    func logout(token: String) -> Single<Void> {
        restApi.requestData(AuthTarget.logout(token: token)).map({ _ in })
    }
}
