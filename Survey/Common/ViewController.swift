//
//  ViewController.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Swinject

class ViewController: UIViewController {
    
    let viewModel: ViewModel?
    let resolver: Resolver
    let isLoading = BehaviorRelay(value: false)
    let error = PublishSubject<Error>()
    
    private lazy var loadingActivity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .white)
        return activity
    }()
    
    init(viewModel: ViewModel?, resolver: Resolver) {
        self.viewModel = viewModel
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
        print("\(String(describing: self)) init")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bindViewModel()
        configLoadingActivity()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel
            .loading
            .asObservable()
            .bind(to: isLoading)
            .disposed(by: rx.disposeBag)
        viewModel.error.drive(onNext: { [weak self] error in
            self?.onError(error: error)
        }).disposed(by: rx.disposeBag)
        isLoading
            .distinctUntilChanged()
            .bind(onNext: { [weak self] loading in
                guard let self = self else { return }
                loading ? self.loadingActivity.startAnimating() : self.loadingActivity.stopAnimating()
                self.loadingActivity.isHidden = !loading || !self.defaultLoadingAnimation
            })
            .disposed(by: rx.disposeBag)
       
    }
    
    func onError(error: Error) {
        if let error = error as? ErrorResponse {
            showAlert(title: "error".localized, message: error.localizedDescription)
            return
        }
        if let error = error as? AppError {
            showAlert(title: "error".localized, message: error.message)
            return
        }
    }
    
    private func configLoadingActivity() {
        view.addSubview(loadingActivity)
        loadingActivity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    var defaultLoadingAnimation: Bool {
        return true
    }

    deinit {
        print("\(String(describing: self)) deinit")
    }
}
