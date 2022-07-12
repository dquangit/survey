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
        container.register(RestApi.self) { _ in
            AlamofireRestApi()
        }
        
        container.register(AuthRepository.self) { r in
            AuthRepositoryImpl(resApi: r.resolve(RestApi.self)!)
        }
    }
}
