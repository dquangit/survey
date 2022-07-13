//
//  SplashViewModel.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import Foundation
import Swinject

class SplashViewModel: ViewModel, ViewModelType {
    
    override init(resolver: Resolver) {
        super.init(resolver: resolver)
        parse()
    }
    
    struct Input {}
    
    struct Output {}
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    private func parse() {
        let response = """
        {
            "id": "9346",
            "type": "token",
            "attributes": {
                "access_token": "-6gSzRMigkaLiZw2OqqjkyqrMVxayt36D2jDMO89adE",
                "token_type": "Bearer",
                "expires_in": 7200,
                "refresh_token": "nmdnsdiL_qRb7ihBUzhCKxSLpWSY-XMg22y9ZGv_f6E",
                "created_at": 1657699455
            }
        }
        """
        let data = Data(response.utf8)
        do {
            let result = try JSONParser.mapObject(LoginResponse.self, data: data)
            print("data \(result.attributes?.createdAt)")
        } catch {
            print(error)
        }
        
    }
}
