//
//  SurveyRepositoryImpl.swift
//  Survey
//
//  Created by Quang Pham on 14/07/2022.
//

import Foundation
import RxSwift
import Swinject

class SurveyRepositoryImpl: SurveyRepository {
    
    private let resolver: Resolver
    private let restApi: RestApi
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.restApi = resolver.resolve(RestApi.self)!
    }
    
    func getSurveyList(page: Int, size: Int) -> Single<DataResponse<[SurveyResponse]>> {
        return restApi
            .request(
                SurveyTarget.getSurverList(
                    page: page,
                    size: size
                )
            )
    }
}
