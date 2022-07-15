//
//  SurveyListViewController.swift
//  Survey
//
//  Created by Quang Pham on 13/07/2022.
//

import UIKit
import RxSwift
import RxCocoa

class SurveyListViewController: ViewController {
    
    private let onRefresh = PublishSubject<Void>()
    
    private lazy var dateView = DateView()
    
    private lazy var userImageView = UIImageView(asset: .userPicture)
    private let onTakeSurvey = PublishSubject<Survey>()
    private let onLoadMore = PublishSubject<Void>()
    
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
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .white.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.hidesForSinglePage = true
        pageControl.isSkeletonable = true
        pageControl.skeletonCornerRadius = 8
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
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dateView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
            } else {
                make.top.equalToSuperview().offset(28)
            }
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(userImageView.snp.left).offset(-20)
        }
        
        userImageView.snp.makeConstraints { make in
            make.centerY.equalTo(dateView)
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(36)
        }
        
        pageControl.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-180)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
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
        
        collectionView
            .rx
            .didEndDecelerating.withLatestFrom(collectionView.rx.contentOffset)
            .map { point in
                Int(point.x/UIScreen.main.bounds.width)
            }.bind(to: pageControl.rx.currentPage)
            .disposed(by: rx.disposeBag)
        
        let loadMoreData = Driver.combineLatest(
            output.surveys ,
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
        
        collectionView.rx.didScroll.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if self.collectionView.contentOffset.x < Capacity.pullToRefreshOffset {
                self.refresh()
            }
        }).disposed(by: rx.disposeBag)
        
        pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                self.collectionView.scrollToItem(
                    at: IndexPath(
                        row: self.pageControl.currentPage,
                        section: 0
                    ),
                    at: .centeredHorizontally,
                    animated: true
                )
            })
            .disposed(by: rx.disposeBag)
        
        isLoading.subscribe(onNext: { [weak self] loading in
            if (loading) {
                self?.pageControl.showAnimatedGradientSkeleton()
                return
            }
            self?.pageControl.hideSkeleton()
        }).disposed(by: rx.disposeBag)
    }
    
    @objc func refresh() {
        onRefresh.onNext(())
    }
    
    override var defaultLoadingAnimation: Bool {
        return false
    }
}
