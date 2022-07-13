//
//  ViewModelType.swift
//  Survey
//
//  Created by Quang Pham on 11/07/2022.
//

import Foundation
import RxSwift
import RxCocoa
import Swinject

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class ViewModel: NSObject {
    
    let resolver: Resolver
    
    let loading = ActivityIndicator()

    let error = ErrorTracker()
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }

}
