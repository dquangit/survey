//
//  AlamofireRestApi.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation
import RxSwift
import Alamofire
import Swinject

class AlamofireRestApi: RestApi {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    func request<T: Decodable>(_ target: TargetType) -> Single<T> {
        return requestData(target).map { data in
            do {
                return try JSONParser.mapObject(DataResponse<T>.self, data: data).data
            } catch {
                self.debugRequest(target: target, error: error)
                throw ErrorResponse.invalidJson
            }
        }
    }
    
    func requestData(_ target: TargetType) -> Single<Data> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create {} }
            let request = Alamofire.request(
                URL(string:  target.baseUrl)!.appendingPathComponent(target.path),
                method: target.method,
                parameters: target.parameters,
                encoding: target.parameterEncoding,
                headers: target.headers
            ).validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        self.debugRequest(target: target, data: data)
                        single(.success(data))
                    case .failure:
                        if let statusCode = response.response?.statusCode,
                           let errorResponse = ErrorResponse(rawValue: statusCode) {
                            self.debugRequest(target: target, error: errorResponse)
                            single(.failure(errorResponse))
                            return
                        }
                        self.debugRequest(target: target, error: ErrorResponse.unknown)
                        single(.failure(ErrorResponse.unknown))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private func debugRequest(target: TargetType, data: Data? = nil, error: Error? = nil) {
        #if DEBUG
        if let data = data {
            debugPrint(
                "REQUEST \(target) SUCCESS",
                try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as Any
            )
        }
        if let error = error {
            debugPrint(
                "REQUEST \(target) FAILED",
                error.localizedDescription
            )
        }
        #endif
    }
}
