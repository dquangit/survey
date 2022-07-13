//
//  SplashViewModel.swift
//  Survey
//
//  Created by Quang Pham on 12/07/2022.
//

import Foundation
import RxSwift
import RxCocoa

class SplashViewModel: ViewModel, ViewModelType {
    
    struct Input {
    }
    
    struct Output {
        let gotoLogin: Driver<Void>
        let gotoSurveyList: Driver<Void>
    }
    
    private let signedIn = BehaviorSubject<Bool?>(value: nil)
    
    func transform(input: Input) -> Output {
        signedIn.onNext(resolver.resolve(AuthRepository.self)!.isSignedIn)
        return Output(
            gotoLogin: signedIn
                .asDriverOnErrorJustComplete()
                .compactMap { $0 }
                .filter { !$0 }
                .map{_ in ()},
            gotoSurveyList: signedIn
                .asDriverOnErrorJustComplete()
                .compactMap { $0 }
                .filter { $0 }
                .map{_ in ()}
        )
    }
}
