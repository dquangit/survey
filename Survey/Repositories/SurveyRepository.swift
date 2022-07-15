//
//  SurveyRepository.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation
import RxSwift

protocol SurveyRepository {
    func getSurveyList(page: Int, size: Int) -> Single<DataResponse<[SurveyResponse]>>
}
