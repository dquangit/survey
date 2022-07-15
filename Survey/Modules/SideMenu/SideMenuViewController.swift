//
//  SideMenuViewController.swift
//  Survey
//
//  Created by Quang Pham on 15/07/2022.
//

import UIKit
import SideMenu

class SideMenuViewController: ViewController {
    
    var onLogoutSuccess: (() -> Void)?
    
    private lazy var backgroundImage = UIImageView(asset: .sideMenuBackground)
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView(asset: .userPicture)
        imageView.isSkeletonable = true
        imageView.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 34)
        return label
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("logout".localized, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.8), for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.4), for: .highlighted)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func makeUI() {
        super.makeUI()
        view.backgroundColor = .white
        view.addSubviews([backgroundImage, nameLabel, userImageView, line, logoutButton])
        backgroundImage.snp.makeConstraints { make in
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
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userImageView)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(userImageView.snp.left).offset(-20)
        }
        
        line.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
            make.right.equalTo(userImageView)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(20)
            make.left.equalTo(nameLabel)
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? SideMenuViewModel else { return }
        let input = SideMenuViewModel.Input(logout: logoutButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.user.drive(onNext: { [weak self] user in
            guard let self = self else { return }
            self.nameLabel.text = user.name
            if let urlString = user.avatarUrl, let url = URL(string: urlString) {
                self.userImageView.kf.setImage(with: url, placeholder: UIImage(asset: .userPicture))
            }
        }).disposed(by: rx.disposeBag)
        
        output.logoutSuccess.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.onLogoutSuccess?()
            }
        }).disposed(by: rx.disposeBag)
    }
}
