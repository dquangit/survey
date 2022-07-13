//
//  AccessTokenProvider.swift
//  Survey
//
//  Created by Quang Pham on 13/07/2022.
//

import Foundation
import RxSwift
import KeychainAccess

protocol AccessTokenProvider {
    func updateToken(token: AccessToken?)
    var authorization: String? { get }
}

class AccessTokenProviderImpl: AccessTokenProvider {
    
    
    private let keychain = Keychain(
        service: Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    )
    
    private var accessToken: AccessToken?
    
    
    init() {
        loadTokenFromKeychain()
    }
    
    func updateToken(token: AccessToken?) {
        self.accessToken = token
        keychain[data: Constants.accessToken] = JSONParser.encodableToData(token)
    }
    
    var authorization: String? {
        guard let token = accessToken?.accessToken,
              let tokenType = accessToken?.tokenType else {
            return nil
        }
        return "\(tokenType) \(token)"
    }
    
    private func loadTokenFromKeychain() {
        guard let data = keychain[data: Constants.accessToken] else {
            return
        }
        accessToken = try? JSONParser.mapObject(AccessToken.self, data: data)
    }
}
