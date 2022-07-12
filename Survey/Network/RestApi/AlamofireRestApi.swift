//
//  AlamofireRestApi.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation
import RxSwift
import Alamofire

class AlamofireRestApi: RestApi {
    
    func updateAuthToken(_ token: String) {
        
    }
    
    func request<T: Decodable>(_ target: TargetType) -> Single<T> {
        return requestData(target).map { data in
            guard let result = try? JSONParser.mapObject(T.self, data: data) else {
                throw ErrorResponse.invalidJson
            }
            return result
        }
    }
    
    func requestData(_ target: TargetType) -> Single<Data> {
        return Single.create { single in
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
                        single(.success(data))
                    case .failure:
                        if let statusCode = response.response?.statusCode,
                           let errorResponse = ErrorResponse(rawValue: statusCode) {
                            single(.failure(errorResponse))
                            return
                        }
                        single(.failure(ErrorResponse.unknown))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
