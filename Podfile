platform :ios, '10.0'

def survey_pods
  pod 'Swinject', '2.8.1'
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'RxGesture'
  pod 'NSObject+Rx'
end


target 'Survey' do
  use_frameworks!
  survey_pods
  pod 'SnapKit', '5.6.0'
  pod 'Alamofire', '4.8.2'
  pod 'IQKeyboardManagerSwift'
  pod 'KeychainAccess'
  pod 'Kingfisher'
  pod 'SkeletonView'
  pod 'SideMenu'
  pod 'Connectivity'

  target 'SurveyTests' do
    inherit! :search_paths
    survey_pods
    pod 'Nimble'
    pod 'Quick'
    pod 'Cuckoo'
  end

  target 'SurveyUITests' do
    # Pods for testing
  end

end
