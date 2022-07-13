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
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? SplashViewModel else {
            return
        }
        let input = SplashViewModel.Input()
        let output = viewModel.transform(input: input)
        output.gotoLogin.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.setViewControllers(
                [self.resolver.resolve(LoginViewController.self)!],
                animated: false
            )
        }).disposed(by: rx.disposeBag)
        
        output.gotoSurveyList.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.setViewControllers(
                [self.resolver.resolve(SurveyListViewController.self)!],
                animated: false
            )
        }).disposed(by: rx.disposeBag)
    }
}
