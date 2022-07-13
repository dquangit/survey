//
//  AppAssembly.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import Foundation
import Swinject

class AppAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SplashViewController.self) { resolver in
            SplashViewController(
                viewModel: SplashViewModel(resolver: resolver),
                resolver: resolver
            )
        }
    
        container.register(LoginViewController.self) { resolver in
            LoginViewController(
                viewModel: LoginViewModel(resolver: resolver),
                resolver: resolver
            )
        }
        
        container.register(SurveyListViewController.self) { resolver in
            SurveyListViewController(
                viewModel: SurveyListViewModel(resolver: resolver),
                resolver: resolver
            )
        }
    }
}
