//
//  SplashViewController.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import UIKit
import SnapKit

class SplashViewController: ViewController {
    
    private lazy var backgroundImageView = UIImageView(asset: .splashBackground)
    private lazy var logoImageView = UIImageView(asset: .logo)
    
    override func makeUI() {
        super.makeUI()
        view.addSubviews([backgroundImageView, logoImageView])
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        navigationController?.setViewControllers(
            [resolver.resolve(LoginViewController.self)!],
            animated: false
        )
    }
}
