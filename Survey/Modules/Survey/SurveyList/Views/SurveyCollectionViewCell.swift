//
//  SurveyCollectionViewCell.swift
//  Survey
//
//  Created by Quang Pham on 14/07/2022.
//

import UIKit

class SurveyCollectionViewCell: UICollectionViewCell, ReusableCell {
    
    private lazy var backgroundImage = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var takeSurveyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(asset: .nextButton), for: .normal)
        return button
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
                titleLabel,
                descriptionLabel,
                takeSurveyButton
            ]
        )

        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(112)
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
    }
    
    func bindData(survey: Survey) {
        titleLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        descriptionLabel.text = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, "
        
    }
}
