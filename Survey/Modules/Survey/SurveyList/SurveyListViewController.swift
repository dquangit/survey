//
//  SurveyListViewController.swift
//  Survey
//
//  Created by Quang Pham on 13/07/2022.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SideMenu

class SurveyListViewController: ViewController {
    
    private let onRefresh = PublishSubject<Void>()
    private let onTakeSurvey = PublishSubject<Survey>()
    private let onLoadMore = PublishSubject<Void>()
    private let onPageChanged = BehaviorSubject<Int>(value: 0)
    private var barStyle: UIStatusBarStyle?

    private lazy var dateView = DateView()

    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView(asset: .userPicture)
        imageView.isSkeletonable = true
        imageView.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.skeletonCornerRadius = 18
        imageView.rx.tap().subscribe(onNext: { [weak self] in
            self?.showSideMenu()
        }).disposed(by: rx.disposeBag)
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            SurveyCollectionViewCell.self,
            forCellWithReuseIdentifier: SurveyCollectionViewCell.identifier
        )
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .zero
        collectionView.isPagingEnabled = true
        collectionView.rx
            .didScroll
            .withLatestFrom(collectionView.rx.contentOffset)
            .map { point in
                Int(point.x/UIScreen.main.bounds.width)
            }.bind(to: pageControl.rx.currentPage)
            .disposed(by: rx.disposeBag)
        collectionView.rx.didScroll.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if self.collectionView.contentOffset.x < Constants.pullToRefreshOffset {
                self.refresh()
            }
        }).disposed(by: rx.disposeBag)
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .white.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.enableSkeletonAnimation(radius: 8)
        if #available(iOS 14.0, *) {
          pageControl.backgroundStyle = .minimal
          pageControl.allowsContinuousInteraction = false
        }
        pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.collectionView.scrollToItem(
                    at: IndexPath(
                        row: self.pageControl.currentPage,
                        section: 0
                    ),
                    at: .left,
                    animated: true
                )
            })
            .disposed(by: rx.disposeBag)
        return pageControl
    }()
    
    override func makeUI() {
        super.makeUI()
        automaticallyAdjustsScrollViewInsets = false
        view.addSubviews([
            collectionView,
            userImageView,
            dateView,
            pageControl
        ])
        view.isSkeletonable = true
        barStyle = preferredStatusBarStyle
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        userImageView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(45)
            } else {
                make.top.equalToSuperview().offset(45)
            }
            make.right.equalToSuperview().offset(-20)
        }
        
        dateView.snp.makeConstraints { make in
            make.centerY.equalTo(userImageView)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(userImageView.snp.left).offset(-20)
        }
        
        pageControl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-170)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(200), execute: {
            self.refresh()
        })
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? SurveyListViewModel else { return }
        
        let input = SurveyListViewModel.Input(
            getSurveyList: onRefresh.asDriverOnErrorJustComplete(),
            loadMore: onLoadMore.asDriverOnErrorJustComplete(),
            onTakeSurvey: onTakeSurvey.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input: input)
        
        output.surveys.drive(
            collectionView.rx.items(
                cellIdentifier: SurveyCollectionViewCell.identifier,
                cellType: SurveyCollectionViewCell.self
            )) { [weak self] (index, value, cell) in
                cell.bindData(survey: value)
                cell.onTakeSurveyTap = {
                    guard let survey = value else {
                        return
                    }
                    self?.onTakeSurvey.onNext(survey)
                }
            }.disposed(by: rx.disposeBag)
        
        output.surveys
            .map{ $0.count }
            .drive(pageControl.rx.numberOfPages)
            .disposed(by: rx.disposeBag)
        
        output.gotoSurveyDetails.drive(onNext: { [weak self] survey in
            guard let self = self,
                  let surveyDetailVC = self.resolver.resolve(SurveyDetailViewController.self, argument: survey) else {
                return
            }
            self.navigationController?.pushViewController(surveyDetailVC, animated: true)
        }).disposed(by: rx.disposeBag)
        
        let loadMoreData = Driver.combineLatest(
            output.surveys,
            output.canLoadMore
        )
        
        collectionView
            .rx
            .willDisplayCell.withLatestFrom(
                loadMoreData,
                resultSelector: { (willDisplayCell, data) -> Bool in
                    let (_, indexPath) = willDisplayCell
                    let (surveys, canLoadMore) = data
                    return indexPath.row == surveys.count - 1 && canLoadMore
                })
            .filter { $0 }
            .mapToVoid()
            .bind(to: onLoadMore)
            .disposed(by: rx.disposeBag)
        
        output.avatarUrl.drive(onNext: { [weak self] url in
            self?.userImageView.kf.setImage(
                with: url,
                placeholder: UIImage(asset: .userPicture)
            )
        }).disposed(by: rx.disposeBag)
        
        isLoading.subscribe(onNext: { [weak self] loading in
            if (loading) {
                self?.view.startSkeleton()
                return
            }
            self?.view.stopSkeleton()
        }).disposed(by: rx.disposeBag)
            
        Observable.combineLatest(
            output.surveys.asObservable(),
            Observable.merge(
                Observable.just(()),
                collectionView.rx.didEndScrollingAnimation.asObservable(),
                collectionView.rx.didEndDecelerating.asObservable()
            )
        )
        .subscribe(
            onNext: { [weak self] (surveys, _) in
                guard let self = self else { return }
                let page = Int(self.collectionView.contentOffset.x/UIScreen.main.bounds.width)
                guard page < surveys.count, let url = surveys[page]?.highResolutionCoverImageUrl else { return }
                self.updateStatusBarByImage(url)
            }).disposed(by: rx.disposeBag)
    }
    
    @objc func refresh() {
        onRefresh.onNext(())
    }
    
    private func showSideMenu() {
        let sideMenuVC = SideMenuViewController(viewModel: SideMenuViewModel(resolver: resolver), resolver: resolver)
        sideMenuVC.onLogoutSuccess = { [weak self] in
            self?.backToLogin()
        }
        let menu = SideMenuNavigationController(rootViewController: sideMenuVC)
        menu.presentationStyle = .menuSlideIn
        self.present(menu, animated: true, completion: nil)
    }
    
    private func backToLogin() {
        let loginVC = resolver.resolve(LoginViewController.self)!
        self.navigationController?.setViewControllers([loginVC], animated: true)
    }
    
    override var defaultLoadingAnimation: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle ?? super.preferredStatusBarStyle
    }
    
    private func updateStatusBarByImage(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success:
                let image = self.view.asImage(
                    bounds: CGRect(
                        x: 0,
                        y: 0,
                        width: self.collectionView.frame.width,
                        height:  UIApplication.shared.statusBarFrame.height
                    )
                )
                let islight = image.isLight ?? false
                self.updateStatusBar(light: !islight)
            default:
                self.updateStatusBar(light: false)
            }
        }
    }
    
    private func updateStatusBar(light: Bool) {
        if #available(iOS 13.0, *) {
            self.barStyle = light ? .lightContent : .darkContent
        } else {
            self.barStyle = light ? .lightContent : .default
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
