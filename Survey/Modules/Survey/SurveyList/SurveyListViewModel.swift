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
        var surveys: Driver<[Survey?]>
        var gotoSurveyDetails: Driver<Survey>
        var canLoadMore: Driver<Bool>
        var avatarUrl: Driver<URL>
    }
    
    private let surveys = BehaviorRelay<[Survey?]>(value: [nil])
    private let pagination = BehaviorRelay<Pagination?>(value: nil)
    private lazy var surveyRepository = resolver.resolve(SurveyRepository.self)!
    private lazy var userRepository = resolver.resolve(UserRepository.self)!

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
            self.surveys.accept([nil])
            self.pagination.accept(nil)
        }
        let page = (pagination.value?.page ?? 0) + 1
        resolver.resolve(SurveyRepository.self)!
            .getSurveyList(page: page, size: Pagination.defaultPageSize)
            .trackActivity(loading)
            .trackError(error)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                var list = self.surveys.value.filter { $0 != nil }
                list.append(contentsOf: response.data?.map { $0.attributes } ?? [])
                if response.meta?.canLoadMore == true {
                    list.append(nil)
                }
                self.surveys.accept(list)
                self.pagination.accept(response.meta)
        }).disposed(by: rx.disposeBag)
    }
}
