//
//  SurveyDetailViewController.swift
//  Survey
//
//  Created by Quang Pham on 14/07/2022.
//

import Foundation
import Swinject

class SurveyDetailViewController: ViewController {
    
    private let survey: Survey
    
    init(viewModel: ViewModel?, resolver: Resolver, survey: Survey) {
        self.survey = survey
        super.init(viewModel: viewModel, resolver: resolver)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var defaultLoadingAnimation: Bool {
        return false
    }
}
