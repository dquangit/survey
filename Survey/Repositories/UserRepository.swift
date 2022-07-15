//
//  UserRepository.swift
//  Survey
//
//  Created by Quang Pham on 15/07/2022.
//

import Foundation
import RxSwift

protocol UserRepository {
    func getUserProfile() -> Single<User?>
    var userObservable: Observable<User?> { get }
}
