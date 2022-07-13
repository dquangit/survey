//
//  AuthRepositoryImpl.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation
import RxSwift
import Swinject

class AuthRepositoryImpl: AuthRepository {
    
    var isSignedIn: Bool {
        return resolver.resolve(AccessTokenProvider.self)!.authorization != nil
    }
    
    private let resolver: Resolver
    private let restApi: RestApi
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.restApi = resolver.resolve(RestApi.self)!
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
