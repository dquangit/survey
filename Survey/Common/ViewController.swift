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

class ViewController: UIViewController {

    var viewModel: ViewModel?
    let isLoading = BehaviorRelay(value: false)
    let error = PublishSubject<Error>()
    
    init(viewModel: ViewModel?) {
          self.viewModel = viewModel
          super.init(nibName: nil, bundle: nil)
            print("\(String(describing: self)) init")
      }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bindViewModel()
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
    }
    
    deinit {
        print("\(String(describing: self)) deinit")
    }
}
