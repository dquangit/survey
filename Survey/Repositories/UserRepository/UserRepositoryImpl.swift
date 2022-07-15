//
//  UserRepositoryImpl.swift
//  Survey
//
//  Created by Quang Pham on 15/07/2022.
//

import Foundation
import RxSwift
import Swinject

class UserRepositoryImpl: NSObject, UserRepository {
    
    private let resolver: Resolver
    private let restApi: RestApi
    private let userSubject = BehaviorSubject<User?>(value: nil)
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.restApi = resolver.resolve(RestApi.self)!
        super.init()
    }
    
    func getUserProfile() -> Single<User?> {
        return Single.create { create in
            let response: Single<UserResponse> = self.restApi.request(UserTarget.getUserProfile, path: "data")
            return response.subscribe(
                onSuccess: { userResponse in
                    self.userSubject.onNext(userResponse.attributes)
                    create(.success(userResponse.attributes))
                }, onFailure: { error in
                    create(.failure(error))
                }
            )
        }
    }
    
    var userObservable: Observable<User?> {
        userSubject.asObserver()
    }
}
