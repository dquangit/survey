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
        
        container.register(UserRepository.self) { resolver in
            UserRepositoryImpl(resolver: resolver)
        }.inObjectScope(.container)
        
        container.register(ConnectivityService.self) { resolver in
            ConnectivityServiceImpl()
        }.inObjectScope(.container)
        
        container.register(RestApi.self) { resolver in
            AlamofireRestApi(resolver: resolver)
        }
        
        container.register(AuthRepository.self) { resolver in
            AuthRepositoryImpl(resolver: resolver)
        }
        
        container.register(SurveyRepository.self) { resolver in
            SurveyRepositoryImpl(resolver: resolver)
        }
    }
}
