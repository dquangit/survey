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
    
    private lazy var dateView = DateView()
    
    private lazy var userImageView = UIImageView(asset: .userPicture)
    
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
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .cyan
        collectionView.contentInset = .zero
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .white.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.hidesForSinglePage = true
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
                make.top.equalTo(view.safeAreaLayoutGuide).offset(28)
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
    
    override func bindViewModel() {
        super.bindViewModel()
        let data = Driver.of([Survey(), Survey(), Survey(), Survey(), Survey(), Survey(), Survey(), Survey(), Survey(), Survey(), Survey(), Survey()])
        data.drive(
            collectionView.rx.items(
                cellIdentifier: SurveyCollectionViewCell.identifier,
                cellType: SurveyCollectionViewCell.self
            )) { (index, value, cell) in
                cell.bindData(survey: Survey())
            }.disposed(by: rx.disposeBag)
        
        data
            .map{ $0.count }
            .drive(pageControl.rx.numberOfPages)
            .disposed(by: rx.disposeBag)
        
        collectionView
            .rx
            .didEndDecelerating.withLatestFrom(collectionView.rx.contentOffset)
            .map { point in
                Int(point.x/UIScreen.main.bounds.width)
            }.bind(to: pageControl.rx.currentPage)
            .disposed(by: rx.disposeBag)
        
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
    }
}
