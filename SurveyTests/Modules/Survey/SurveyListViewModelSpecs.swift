//
//  SurveyListViewModelSpecs.swift
//  SurveyTests
//
//  Created by Quang Pham on 15/07/2022.
//

import Quick
import Nimble
import Swinject
import Cuckoo
import RxSwift
import RxCocoa
@testable import Survey

class SurveyListViewModelSpecs: QuickSpec {
    
    override func spec() {
        
        var getSurveyList: PublishSubject<Void>!
        var loadMore: PublishSubject<Void>!
        var takeSurvey: PublishSubject<Survey>!
        var viewModel: SurveyListViewModel!
        var output: SurveyListViewModel.Output!
        var disposeBag: DisposeBag!

        var surveys: [Survey?]!
        var canLoadMore: Bool?
        
        describe("SurveyListViewModelSpecs") {
            
            beforeEach {
                getSurveyList = PublishSubject<Void>()
                loadMore = PublishSubject<Void>()
                takeSurvey = PublishSubject<Survey>()
                viewModel = SurveyListViewModel(resolver: self.setupContainer())
                disposeBag = DisposeBag()
                output = viewModel.transform(
                    input: SurveyListViewModel.Input(
                        getSurveyList: getSurveyList.asDriverOnErrorJustComplete(),
                        loadMore: loadMore.asDriverOnErrorJustComplete(),
                        onTakeSurvey: takeSurvey.asDriverOnErrorJustComplete()
                    )
                )
                output.surveys.drive(onNext: { result in
                    surveys = result
                }).disposed(by: disposeBag)
                
                output.canLoadMore.drive(onNext: { result in
                    canLoadMore = result
                }).disposed(by: disposeBag)
            }
            
            afterEach {
                disposeBag = nil
                surveys = nil
                canLoadMore = nil
            }

            context("get list surveys") {
                
                it ("get first page - expected data, can load more and placeholder item") {
                    getSurveyList.onNext(())
                    expect(surveys.count).to(equal(Pagination.defaultPageSize + 1))
                    expect(canLoadMore).to(beTrue())
                    expect(surveys[surveys.count - 1]).to(beNil())
                }
                
                it ("do pagination to the last page - expected data, can not load more and dont have placeholder item") {
                    getSurveyList.onNext(())
                    loadMore.onNext(())
                    expect(surveys.count).to(equal(Pagination.defaultPageSize * 2))
                    expect(canLoadMore).notTo(beTrue())
                }
            }
            
            context("get list surveys out of range") {
                it ("expected data not updated") {
                    getSurveyList.onNext(())
                    loadMore.onNext(())
                    let totalCount = surveys.count
                    
                    loadMore.onNext(())
                    expect(surveys.count).to(equal(totalCount))
                    expect(canLoadMore).notTo(beTrue())
                }
            }
        }
    }
    
    private func setupContainer() -> Container {
        let mockSurveyRepository = MockSurveyRepository()
        let mockUserRepository = MockUserRepository()
        stub(mockSurveyRepository) { stub in

            when(stub.getSurveyList(page: 1, size: Pagination.defaultPageSize))
                .thenReturn(Single.just(self.generateMockData(from: 0, to: 5, page: 1)))
            
            when(stub.getSurveyList(page: 2, size: Pagination.defaultPageSize))
                .thenReturn(Single.just(self.generateMockData(from: 5, to: 10, page: 2)))
            
            when(stub.getSurveyList(page: 3, size: Pagination.defaultPageSize))
                .thenReturn(Single.just(DataResponse<[SurveyResponse]>()))
        }
        
        stub(mockUserRepository) { stub in
            let mockUser = User()
            when(stub.getUserProfile()).thenReturn(Single.just(mockUser))
            when(stub.userObservable.get).thenReturn(Observable.just(mockUser))
        }
        
        let container = Container()
        container.register(SurveyRepository.self) { r in
            mockSurveyRepository
        }
        container.register(UserRepository.self) { r in
            mockUserRepository
        }
        return container
    }
    
    private func generateMockData(from: Int, to: Int, page: Int) -> DataResponse<[SurveyResponse]> {
        return DataResponse(
            data: (from..<to).map {
                SurveyResponse(
                    id: "\($0 + 1)",
                    attributes:
                        Survey(
                            title: "Mock survey title",
                            description: "Mock survey description",
                            coverImageUrl: "Mock survey cover url"
                        )
                )
            },
            meta: Pagination(
                page: page,
                pages: 2,
                pageSize: Pagination.defaultPageSize
            )
        )
    }
}
