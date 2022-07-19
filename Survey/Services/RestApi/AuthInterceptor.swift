//
//  AuthInterceptor.swift
//  Survey
//
//  Created by Quang Pham on 19/07/2022.
//

import Alamofire
import Swinject

class AuthRequestAdapter: NSObject, RequestAdapter {

    private let lock = NSLock()
    private let resolver: Resolver

    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    private lazy var accessTokenProvider = resolver.resolve(AccessTokenProvider.self)!
    private lazy var restApi = resolver.resolve(RestApi.self)!


    init(resolver: Resolver) {
        self.resolver = resolver
        super.init()
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        let refreshTokenTarget = AuthTarget.refreshToken(refreshToken: "")
        let accessToken = accessTokenProvider.accessToken
        
        guard let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(refreshTokenTarget.baseUrl),  !urlString.hasSuffix(refreshTokenTarget.path),
              let authorization = accessToken?.authorization else {
            return urlRequest
        }
        urlRequest.setValue(authorization, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}


extension AuthRequestAdapter: RequestRetrier {

    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock()
        defer { lock.unlock() }
        guard let response = request.task?.response as? HTTPURLResponse,
              let error = ErrorResponse(rawValue: response.statusCode),
                error == ErrorResponse.unauthorized else {
            completion(false, 0.0)
            return
        }
    
        requestsToRetry.append(completion)
        guard !isRefreshing else { return }
        restApi.refreshToken().subscribe(onSuccess: { [weak self] token in
            self?.accessTokenProvider.updateToken(token: token)
            self?.requestsToRetry.forEach { $0(true, 0.0) }
            self?.requestsToRetry.removeAll()
        }, onFailure: { [weak self] _ in
            self?.requestsToRetry.forEach { $0(false, 0.0) }
            self?.requestsToRetry.removeAll()
        }).disposed(by: rx.disposeBag)
    }
}
