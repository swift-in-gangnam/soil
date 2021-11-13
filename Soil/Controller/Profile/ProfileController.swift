//
//  ProfileController.swift
//  Soil
//
//  Created by dykoon on 2021/11/11.
//

import UIKit
import SnapKit

protocol ProfileControllerDelegate: AnyObject {
  func didTapUserStatBtn()
}

class ProfileController: UIViewController {
  
  // MARK: - Properties
  
  weak var delegate: ProfileControllerDelegate?
  
  private let profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.backgroundColor = .lightGray
    iv.layer.cornerRadius = 100 / 2
    return iv
  }()
  
  private let fullnameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.notoSansKR(size: 22, family: .bold)
    label.text = "권동영"
    return label
  }()
  
  private let usernameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.ceraPro(size: 15, family: .medium)
    label.text = "@d_oooong"
    return label
  }()
  
  private lazy var followersBtn: UIButton = {
    let btn = UIButton(type: .system)
    btn.addTarget(self, action: #selector(didTapFollowersBtn), for: .touchUpInside)
    return btn
  }()
  
  private lazy var followingBtn: UIButton = {
    let btn = UIButton(type: .system)
    btn.addTarget(self, action: #selector(didTapFollowingBtn), for: .touchUpInside)
    return btn
  }()
  
  private lazy var editProfileFollowButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = .white
    button.setTitle("Edit Profile", for: .normal)
    button.titleLabel?.font = UIFont.ceraPro(size: 17, family: .bold)
    button.setTitleColor(.systemGray2, for: .normal)
    button.layer.cornerRadius = 10
    button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
    return button
  }()
  
  private let bioLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.notoSansKR(size: 14, family: .regular)
    label.text = "iOS 개발자를 꿈꾸는 학생입니다.\n새로운 기술을 학습하고, 직접 적용해보는 경험을 좋아해 적용해보기 위해 많은 서비스들을 개발 / 배포 / 운영하고 있습니다.\n함께라는 가치를 중요시합니다. 혼자서는 하지 못 하는 일을 같은 지향점을 가진 동료들과 발전하고 싶습니다.\n\nMake It Count!!"
    return label
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  // MARK: - Action
  
  @objc func handleEditProfileFollowTapped() {
    let controller = EditProfileController()
    controller.modalPresentationStyle = .fullScreen
    self.present(controller, animated: true, completion: nil)
  }
  
  @objc func didTapFollowersBtn() {
    delegate?.didTapUserStatBtn()
  }
  
  @objc func didTapFollowingBtn() {
    delegate?.didTapUserStatBtn()
  }
  
  // MARK: - Helpers
  
  private func configure() {
    view.addSubview(profileImageView)
    
    profileImageView.snp.makeConstraints { make in
      make.top.equalTo(self.view.snp.top).offset(24)
      make.width.height.equalTo(100)
      make.centerX.equalToSuperview()
    }
    
    view.addSubview(fullnameLabel)
    fullnameLabel.snp.makeConstraints { make in
      make.top.equalTo(self.profileImageView.snp.bottom).offset(15)
      make.centerX.equalToSuperview()
    }
    
    view.addSubview(usernameLabel)
    usernameLabel.snp.makeConstraints { make in
      make.top.equalTo(self.fullnameLabel.snp.bottom).offset(4)
      make.centerX.equalToSuperview()
    }
    
    let userStatDivider = UIView()
    view.addSubview(userStatDivider)
    userStatDivider.snp.makeConstraints { make in
      make.top.equalTo(self.usernameLabel.snp.bottom).offset(11)
      make.centerX.equalToSuperview()
      make.height.equalTo(30)
      make.width.equalTo(1)
    }
    userStatDivider.backgroundColor = .systemGray3
    
    view.addSubview(followersBtn)
    followersBtn.snp.makeConstraints { make in
      make.trailing.equalTo(userStatDivider.snp.leading).offset(-20)
      make.centerY.equalTo(userStatDivider.snp.centerY)
    }
    followersBtn.setAttributedTitle(attributedStatText(label: "팔로워  ", value: 120), for: .normal)
    
    view.addSubview(followingBtn)
    followingBtn.snp.makeConstraints { make in
      make.leading.equalTo(userStatDivider.snp.trailing).offset(20)
      make.centerY.equalTo(userStatDivider.snp.centerY)
    }
    followingBtn.setAttributedTitle(attributedStatText(label: "팔로잉  ", value: 78), for: .normal)
    
    view.addSubview(editProfileFollowButton)
    editProfileFollowButton.snp.makeConstraints { make in
      make.top.equalTo(userStatDivider.snp.bottom).offset(12)
      make.centerX.equalToSuperview()
      make.width.equalTo(150)
      make.height.equalTo(40)
    }
    
    let divider = UIView()
    view.addSubview(divider)
    divider.snp.makeConstraints { make in
      make.top.equalTo(editProfileFollowButton.snp.bottom).offset(20)
      make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
      make.height.equalTo(1)
    }
    divider.backgroundColor = .systemGray3
    
    view.addSubview(bioLabel)
    bioLabel.snp.makeConstraints { make in
      make.top.equalTo(divider.snp.bottom).offset(20)
      make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-16)
    }
    
  }
  
  func attributedStatText(label: String, value: Int) -> NSAttributedString {
    let attributedText = NSMutableAttributedString(
      string: label,
      attributes: [.font: UIFont.notoSansKR(size: 13, family: .medium), .foregroundColor: UIColor.black]
    )
    attributedText.append(
      NSAttributedString(
        string: "\(value)",
        attributes: [.font: UIFont.ceraPro(size: 20, family: .bold), .foregroundColor: UIColor.black]
      )
    )
      
    return attributedText
  }
   
}
