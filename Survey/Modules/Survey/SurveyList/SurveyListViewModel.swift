//
//  SurveyListViewModel.swift
//  Survey
//
//  Created by Quang Pham on 13/07/2022.
//

import Foundation
import RxCocoa
import RxSwift

class SurveyListViewModel: ViewModel, ViewModelType {
    
    struct Input {
        var getSurveyList: Driver<Void>
        var loadMore: Driver<Void>
        var onTakeSurvey: Driver<Survey>
    }
    
    struct Output {
        var surveys: Driver<[Survey]>
        var gotoSurveyDetails: Driver<Survey>
        var canLoadMore: Driver<Bool>
        var avatarUrl: Driver<URL>
    }
    
    private let surveys = BehaviorRelay<[Survey]>(value: [])
    private let pagination = BehaviorRelay<Pagination?>(value: nil)
    private lazy var surveyRepository = resolver.resolve(SurveyRepository.self)!
    private lazy var userRepository = resolver.resolve(UserRepository.self)!
    private lazy var connectivityService = resolver.resolve(ConnectivityService.self)!

    func transform(input: Input) -> Output {
        
        userRepository
            .getUserProfile()
            .subscribe(onSuccess: { _ in })
            .disposed(by: rx.disposeBag)
        
        input.getSurveyList.drive(onNext: { [weak self] in
            self?.getSurvey(loadMore: false)
        }).disposed(by: rx.disposeBag)
        
        input.loadMore.drive(onNext: { [weak self] in
            self?.getSurvey(loadMore: true)
        }).disposed(by: rx.disposeBag)
        
        return Output(
            surveys: surveys.asDriver(),
            gotoSurveyDetails: input.onTakeSurvey,
            canLoadMore: pagination
                .compactMap { $0 }
                .map { $0.canLoadMore }
                .asDriverOnErrorJustComplete(),
            avatarUrl: userRepository
                .userObservable
                .compactMap { $0?.avatarUrl }
                .compactMap { URL(string: $0) }
                .asDriverOnErrorJustComplete()
        )
    }
    
    private func getSurvey(loadMore: Bool) {
        if !loadMore {
            self.pagination.accept(nil)
        }
        let page = (pagination.value?.page ?? 0) + 1
        resolver.resolve(SurveyRepository.self)!
            .getSurveyList(page: page, size: Pagination.defaultPageSize)
            .trackActivity(loading)
            .trackError(error)
            .retry(when: { [weak self] error in
                return error.flatMapLatest { error -> Observable<Void> in
                    guard let self = self, let errorResponse = error as? ErrorResponse,
                          errorResponse == ErrorResponse.noInternetConnection else {
                        return .error(error)
                        
                    }
                    return self.connectivityService
                        .onConnectStatusChanged
                        .filter { $0 }
                        .mapToVoid()
                }
            })
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                let responseSurveys = response.data?.compactMap { $0.attributes } ?? []
                let list = loadMore ? self.surveys.value + responseSurveys : responseSurveys
                self.surveys.accept(list)
                self.pagination.accept(response.meta)
        }).disposed(by: rx.disposeBag)
    }
}
