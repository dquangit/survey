//
//  RepositoryAssembly.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import Foundation
import Swinject

class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(AccessTokenProvider.self) { resolver in
            AccessTokenProviderImpl()
        }.inObjectScope(.container)
        
        container.register(RestApi.self) { resolver in
            AlamofireRestApi(resolver: resolver)
        }
        
        container.register(AuthRepository.self) { resolver in
            AuthRepositoryImpl(resApi: resolver.resolve(RestApi.self)!)
        }
    }
}
