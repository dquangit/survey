// MARK: - Mocks generated from file: Survey/Repositories/AuthRepository.swift at 2022-07-15 06:48:27 +0000

//
//  AuthRepository.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Cuckoo
@testable import Survey

import Foundation
import RxSwift






 class MockAuthRepository: AuthRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = AuthRepository
    
     typealias Stubbing = __StubbingProxy_AuthRepository
     typealias Verification = __VerificationProxy_AuthRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AuthRepository?

     func enableDefaultImplementation(_ stub: AuthRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     var isSignedIn: Bool {
        get {
            return cuckoo_manager.getter("isSignedIn",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isSignedIn)
        }
        
    }
    
    

    

    
    
    
    
     func loginByEmail(email: String, password: String) -> Single<LoginResponse> {
        
    return cuckoo_manager.call(
    """
    loginByEmail(email: String, password: String) -> Single<LoginResponse>
    """,
            parameters: (email, password),
            escapingParameters: (email, password),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.loginByEmail(email: email, password: password))
        
    }
    
    
    
    
    
     func logout(token: String) -> Single<Void> {
        
    return cuckoo_manager.call(
    """
    logout(token: String) -> Single<Void>
    """,
            parameters: (token),
            escapingParameters: (token),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.logout(token: token))
        
    }
    
    

     struct __StubbingProxy_AuthRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var isSignedIn: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAuthRepository, Bool> {
            return .init(manager: cuckoo_manager, name: "isSignedIn")
        }
        
        
        
        
        
        func loginByEmail<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(email: M1, password: M2) -> Cuckoo.ProtocolStubFunction<(String, String), Single<LoginResponse>> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: email) { $0.0 }, wrap(matchable: password) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAuthRepository.self, method:
    """
    loginByEmail(email: String, password: String) -> Single<LoginResponse>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func logout<M1: Cuckoo.Matchable>(token: M1) -> Cuckoo.ProtocolStubFunction<(String), Single<Void>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: token) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAuthRepository.self, method:
    """
    logout(token: String) -> Single<Void>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AuthRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var isSignedIn: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isSignedIn", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func loginByEmail<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(email: M1, password: M2) -> Cuckoo.__DoNotUse<(String, String), Single<LoginResponse>> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: email) { $0.0 }, wrap(matchable: password) { $0.1 }]
            return cuckoo_manager.verify(
    """
    loginByEmail(email: String, password: String) -> Single<LoginResponse>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func logout<M1: Cuckoo.Matchable>(token: M1) -> Cuckoo.__DoNotUse<(String), Single<Void>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: token) { $0 }]
            return cuckoo_manager.verify(
    """
    logout(token: String) -> Single<Void>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}

 class AuthRepositoryStub: AuthRepository {
    
    
    
    
     var isSignedIn: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    

    

    
    
    
    
     func loginByEmail(email: String, password: String) -> Single<LoginResponse>  {
        return DefaultValueRegistry.defaultValue(for: (Single<LoginResponse>).self)
    }
    
    
    
    
    
     func logout(token: String) -> Single<Void>  {
        return DefaultValueRegistry.defaultValue(for: (Single<Void>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Survey/Repositories/SurveyRepository.swift at 2022-07-15 06:48:27 +0000

//
//  SurveyRepository.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Cuckoo
@testable import Survey

import Foundation
import RxSwift






 class MockSurveyRepository: SurveyRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = SurveyRepository
    
     typealias Stubbing = __StubbingProxy_SurveyRepository
     typealias Verification = __VerificationProxy_SurveyRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: SurveyRepository?

     func enableDefaultImplementation(_ stub: SurveyRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func getSurveyList(page: Int, size: Int) -> Single<DataResponse<[SurveyResponse]>> {
        
    return cuckoo_manager.call(
    """
    getSurveyList(page: Int, size: Int) -> Single<DataResponse<[SurveyResponse]>>
    """,
            parameters: (page, size),
            escapingParameters: (page, size),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getSurveyList(page: page, size: size))
        
    }
    
    

     struct __StubbingProxy_SurveyRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getSurveyList<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(page: M1, size: M2) -> Cuckoo.ProtocolStubFunction<(Int, Int), Single<DataResponse<[SurveyResponse]>>> where M1.MatchedType == Int, M2.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, Int)>] = [wrap(matchable: page) { $0.0 }, wrap(matchable: size) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSurveyRepository.self, method:
    """
    getSurveyList(page: Int, size: Int) -> Single<DataResponse<[SurveyResponse]>>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_SurveyRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getSurveyList<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(page: M1, size: M2) -> Cuckoo.__DoNotUse<(Int, Int), Single<DataResponse<[SurveyResponse]>>> where M1.MatchedType == Int, M2.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, Int)>] = [wrap(matchable: page) { $0.0 }, wrap(matchable: size) { $0.1 }]
            return cuckoo_manager.verify(
    """
    getSurveyList(page: Int, size: Int) -> Single<DataResponse<[SurveyResponse]>>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}

 class SurveyRepositoryStub: SurveyRepository {
    

    

    
    
    
    
     func getSurveyList(page: Int, size: Int) -> Single<DataResponse<[SurveyResponse]>>  {
        return DefaultValueRegistry.defaultValue(for: (Single<DataResponse<[SurveyResponse]>>).self)
    }
    
    
}




