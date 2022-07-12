//
//  RestApi.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation
import RxSwift

protocol RestApi {
    func updateAuthToken(_ token: String)
    func request<T: Decodable>(_ target: TargetType) -> Single<T>
    func requestData(_ target: TargetType) -> Single<Data>
}
