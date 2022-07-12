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
        container.register(SplashViewController.self) { r in
            SplashViewController(viewModel: SplashViewModel())
        }
    }
}
