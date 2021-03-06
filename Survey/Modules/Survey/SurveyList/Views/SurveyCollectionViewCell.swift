//
//  SurveyCollectionViewCell.swift
//  Survey
//
//  Created by Quang Pham on 14/07/2022.
//

import UIKit
import Kingfisher
import SkeletonView

class SurveyCollectionViewCell: UICollectionViewCell, ReusableCell {
    
    var onTakeSurveyTap: (() -> Void)?
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.alpha = 0.6
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.numberOfLines = 2
        label.enableSkeletonAnimation(radius: 8)
        label.linesCornerRadius = 8
        label.skeletonTextNumberOfLines = 2
        label.skeletonTextLineHeight = .fixed(20)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.numberOfLines = 2
        label.enableSkeletonAnimation(radius: 8)
        label.linesCornerRadius = 8
        label.skeletonTextNumberOfLines = 2
        label.skeletonTextLineHeight = .fixed(20)
        return label
    }()
    
    private lazy var takeSurveyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(asset: .nextButton), for: .normal)
        button.rx.tap.subscribe(onNext: { [weak self] in
            self?.onTakeSurveyTap?()
        }).disposed(by: rx.disposeBag)
        return button
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.black.withAlphaComponent(0.01).cgColor
           
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        contentView.addSubviews(
            [
                backgroundImage,
                overlayView,
                titleLabel,
                descriptionLabel,
                takeSurveyButton
            ]
        )

        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(contentView.snp.bottom).inset(150)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(takeSurveyButton.snp.left).offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        takeSurveyButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(descriptionLabel)
            make.size.equalTo(56)
        }
        contentView.enableSkeletonAnimation()
    }
    
    func bindData(survey: Survey?) {
        if let urlString = survey?.highResolutionCoverImageUrl, let url = URL(string: urlString) {
            backgroundImage.kf.setImage(with: url, placeholder: UIImage(asset: .darkGradient))
        } else {
            backgroundImage.image = UIImage(asset: .darkGradient)
        }
        takeSurveyButton.isHidden = survey == nil
        guard let survey = survey else {
            contentView.startSkeleton()
            titleLabel.startSkeleton()
            return
        }
        contentView.stopSkeleton()
        titleLabel.text = survey.title
        descriptionLabel.text = survey.description
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
