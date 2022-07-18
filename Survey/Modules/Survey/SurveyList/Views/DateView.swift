//
//  DateView.swift
//  Survey
//
//  Created by Quang Pham on 14/07/2022.
//

import UIKit

class DateView: UIView {

    private lazy var weekDateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.isSkeletonable = true
        label.skeletonTextLineHeight = .fixed(20)
        label.linesCornerRadius = 8
        label.text = DateUtils.dateInWeek(Date())?.uppercased()
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = .white
        label.text = "today".localized
        label.isSkeletonable = true
        label.skeletonTextLineHeight = .fixed(20)
        label.linesCornerRadius = 8
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        makeUI()
        isSkeletonable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        addSubviews([weekDateLabel, dateLabel])
        weekDateLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(weekDateLabel.snp.bottom).offset(4)
        }
    }

}
