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
    private let adapter: AuthRequestAdapter
    private let sessionManager: Alamofire.SessionManager
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.adapter = AuthRequestAdapter(resolver: resolver)
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Constants.requestTimeOutInterval
        self.sessionManager = Alamofire.SessionManager(configuration: config)
        self.sessionManager.adapter = adapter
        self.sessionManager.retrier = adapter
    }
    
    func request<T: Decodable>(_ target: TargetType, path: String?) -> Single<T> {
        return requestData(target).map { data in
            do {
                return try JSONParser.mapObject(T.self, data: data, path: path)
            } catch {
                self.debugRequest(target: target, error: error)
                throw ErrorResponse.invalidJson
            }
        }
    }
    
    func requestData(_ target: TargetType) -> Single<Data> {
        return Single.create { [weak self] single in
            guard let self = self else { return Disposables.create {} }
            return self.requestHeader(target)
                .subscribe(
                    onSuccess: { headers in
                        self.sessionManager.request(
                            URL(string: target.baseUrl)!.appendingPathComponent(target.path),
                            method: target.method,
                            parameters: target.parameters,
                            encoding: target.parameterEncoding,
                            headers: headers
                        ).validate()
                            .responseData { response in
                                switch response.result {
                                case .success(let data):
                                    self.debugRequest(target: target, data: data)
                                    single(.success(data))
                                case .failure(let error):
                                    if let error = error as? URLError,
                                        (error.code == .notConnectedToInternet || error.code == .timedOut) {
                                        self.debugRequest(target: target, error: ErrorResponse.noInternetConnection)
                                        single(.failure(ErrorResponse.noInternetConnection))
                                        return
                                    }
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
                    }, onFailure: { error in
                        single(.failure(error))
                    }
                )
        }
    }
    
    private func requestHeader(_ target: TargetType) -> Single<[String: String]> {
        guard target.authorizationRequired,
              let accessToken = resolver.resolve(AccessTokenProvider.self)?
            .accessToken else {
            return Single.just(target.headers)
        }
        return Single.just(target
            .headers
            .merging(
                ["Authorization": accessToken.authorization ?? ""],
                uniquingKeysWith: { (_, new) in new }
            )
        )
    }
    
    func refreshToken() -> Single<AccessToken?> {
        guard let tokenProvider = self.resolver.resolve(AccessTokenProvider.self),
              let refreshToken = tokenProvider.accessToken?.refreshToken else {
            return Single.just(nil)
        }
        let refresh: Single<LoginResponse> = self.request(
            AuthTarget.refreshToken(
                refreshToken: refreshToken
            ),
            path: "data"
        )
        return refresh.map { $0.attributes }
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
