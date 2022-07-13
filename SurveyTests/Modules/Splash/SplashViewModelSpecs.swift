//
//  SplashViewModelSpecs.swift
//  SurveyTests
//
//  Created by Quang Pham on 13/07/2022.
//

import Quick
import Nimble
import Swinject
import Cuckoo
import RxSwift
import RxCocoa
@testable import Survey

class SplashViewModelSpecs: QuickSpec {
    override func spec() {
        
        var viewModel: SplashViewModel!
        var trigger: PublishSubject<Void>!
        var output: SplashViewModel.Output!
        var disposeBag: DisposeBag!
        var navigateToLogin: Bool?
        var navigateToSurveyList: Bool?
        var container: Container!
        var mockAuthRepository: MockAuthRepository!
        
        describe("SplashViewModelSpecs") {
            
            beforeEach {
                container = Container()
                mockAuthRepository = MockAuthRepository()
                container.register(AuthRepository.self) { _ in
                    mockAuthRepository
                }
                
                trigger = PublishSubject<Void>()
                viewModel = SplashViewModel(resolver: container)
                output = viewModel.transform(
                    input: SplashViewModel.Input(
                        trigger: trigger.asDriverOnErrorJustComplete()
                    )
                )
                disposeBag = DisposeBag()
                
                output.gotoLogin.drive(onNext: {
                    navigateToLogin = true
                }).disposed(by: disposeBag)
                
                output.gotoSurveyList.drive(onNext: {
                    navigateToSurveyList = true
                }).disposed(by: disposeBag)
            }
            
            afterEach {
                viewModel = nil
                disposeBag = nil
                navigateToSurveyList = nil
                navigateToLogin = nil
            }
            
            context("get saved token") {
                
                it("token not empty - expected navigate to survey list") {
                    stub(mockAuthRepository) { stub in
                        when(stub.isSignedIn).get.thenReturn(true)
                    }
                    trigger.onNext(())
                    expect(navigateToSurveyList).to(beTrue())
                }
            }
            
            
            it("token empty - expected navigate to login screen") {
                stub(mockAuthRepository) { stub in
                    when(stub.isSignedIn).get.thenReturn(false)
                }
                trigger.onNext(())
                expect(navigateToLogin).to(beTrue())
            }
        }
    }
    
    private func setupContainer() -> Container {
        let mockAuthRepository = MockAuthRepository()
        stub(mockAuthRepository) { stub in
            when(
                stub.loginByEmail(
                    email: "correct@email.com",
                    password: "correctPassword"
                )
            )
            .thenReturn(Single.just(LoginResponse()))
            
            when(
                stub.loginByEmail(
                    email: "wrong@email.com",
                    password: "wrongPassword"
                )
            )
            .thenReturn(Single<LoginResponse>.error(ErrorResponse.badRequest))
        }
        let container = Container()
        container.register(AuthRepository.self) { r in
            mockAuthRepository
        }
        return container
    }
}
