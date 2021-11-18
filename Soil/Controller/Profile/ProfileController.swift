//
//  ProfileController.swift
//  Soil
//
//  Created by dykoon on 2021/11/11.
//

import UIKit

import Kingfisher

protocol ProfileControllerDelegate: AnyObject {
  func didTapUserStatBtn()
}

class ProfileController: UIViewController {

  private enum Font {
    static let fullnameLabel = UIFont.notoSansKR(size: 22, family: .bold)
    static let usernameLabel = UIFont.ceraPro(size: 15, family: .medium)
    static let editProfileFollowButton = UIFont.ceraPro(size: 17, family: .bold)
    static let bioLabel = UIFont.notoSansKR(size: 14, family: .regular)
  }
  
  // MARK: - Properties
  
  var viewModel: ProfileViewModel? {
    didSet { updateUI() }
  }
  
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
    label.font = Font.fullnameLabel
    return label
  }()
  
  private let usernameLabel: UILabel = {
    let label = UILabel()
    label.font = Font.usernameLabel
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
    button.titleLabel?.font = Font.editProfileFollowButton
    button.setTitleColor(.systemGray2, for: .normal)
    button.layer.cornerRadius = 10
    button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
    return button
  }()
  
  private let bioLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = Font.bioLabel
    return label
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
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
  
  private func configureUI() {
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
    
    view.addSubview(followingBtn)
    followingBtn.snp.makeConstraints { make in
      make.leading.equalTo(userStatDivider.snp.trailing).offset(20)
      make.centerY.equalTo(userStatDivider.snp.centerY)
    }
    
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
  
  private func updateUI() {
    guard let viewModel = viewModel else { return }
    
    profileImageView.kf.setImage(with: viewModel.profileImageURL)
    fullnameLabel.text = viewModel.fullname
    usernameLabel.text = viewModel.username
    followersBtn.setAttributedTitle(viewModel.numberOfFollowers, for: .normal)
    followingBtn.setAttributedTitle(viewModel.numberOfFollowing, for: .normal)
    bioLabel.text = viewModel.bio
  }
}
