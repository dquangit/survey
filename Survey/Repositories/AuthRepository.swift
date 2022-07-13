//
//  AuthRepository.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func loginByEmail(email: String, password: String) -> Single<LoginResponse>
    func logout(token: String) -> Single<Void>
    
    var isSignedIn: Bool { get }
}
