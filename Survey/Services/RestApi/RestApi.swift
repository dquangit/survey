//
//  RestApi.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation
import RxSwift

protocol RestApi {
    func request<T: Decodable>(_ target: TargetType, path: String?) -> Single<T>
    func requestData(_ target: TargetType) -> Single<Data>
}

extension RestApi {
    func request<T: Decodable>(_ target: TargetType) -> Single<T> {
        return request(target, path: nil)
    }
}
