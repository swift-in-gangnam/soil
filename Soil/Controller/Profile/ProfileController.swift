//
//  ProfileController.swift
//  Soil
//
//  Created by dykoon on 2021/11/11.
//

import UIKit
import KeychainAccess

protocol ProfileControllerDelegate: AnyObject {
  func didTapUserStatBtn()
}

class ProfileController: UIViewController {

  private enum Font {
    static let fullnameLabel = UIFont.notoSansKR(size: 22, family: .bold)
    static let nicknameLabel = UIFont.ceraPro(size: 15, family: .medium)
    static let followButton = UIFont.ceraPro(size: 17, family: .bold)
    static let bioLabel = UIFont.notoSansKR(size: 14, family: .regular)
  }
  
  // MARK: - Properties
  
  var viewModel: ProfileViewModel? {
    didSet { bindViewModel() }
  }
  
  weak var delegate: ProfileControllerDelegate?
  private let keychain = Keychain(service: "com.chuncheonian.Soil")
  
  private let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.backgroundColor = .lightGray
    $0.layer.cornerRadius = 100 / 2
  }
  
  private let fullnameLabel = UILabel().then {
    $0.font = Font.fullnameLabel
  }
  
  private let nicknameLabel = UILabel().then {
    $0.font = Font.nicknameLabel
  }
  
  private lazy var followersBtn = UIButton(type: .system).then {
    $0.addTarget(self, action: #selector(didTapFollowersBtn), for: .touchUpInside)
  }
  
  private lazy var followingBtn = UIButton(type: .system).then {
    $0.addTarget(self, action: #selector(didTapFollowingBtn), for: .touchUpInside)
  }
  
  private lazy var followButton = UIButton(type: .system).then {
    $0.titleLabel?.font = Font.followButton
    $0.layer.cornerRadius = 10
    $0.addTarget(self, action: #selector(handleFollowButtonTapped), for: .touchUpInside)
  }
  
  private let bioLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.font = Font.bioLabel
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - Action
  
  @objc func handleFollowButtonTapped() {
    guard let viewModel = viewModel else { return }
    
    // Edit Profile
    if viewModel.user.isCurrentUser {
      let controller = EditProfileController()
      controller.viewModel = ProfileViewModel(user: viewModel.user)
      controller.delegate = self
      let nav = UINavigationController(rootViewController: controller)
      nav.modalPresentationStyle = .fullScreen
      self.present(nav, animated: true, completion: nil)
    }
    
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
    
    view.addSubview(nicknameLabel)
    nicknameLabel.snp.makeConstraints { make in
      make.top.equalTo(self.fullnameLabel.snp.bottom).offset(4)
      make.centerX.equalToSuperview()
    }
    
    let userStatDivider = UIView()
    view.addSubview(userStatDivider)
    userStatDivider.snp.makeConstraints { make in
      make.top.equalTo(self.nicknameLabel.snp.bottom).offset(11)
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
    
    view.addSubview(followButton)
    followButton.snp.makeConstraints { make in
      make.top.equalTo(userStatDivider.snp.bottom).offset(12)
      make.centerX.equalToSuperview()
      make.width.equalTo(150)
      make.height.equalTo(40)
    }
    
    let divider = UIView()
    view.addSubview(divider)
    divider.snp.makeConstraints { make in
      make.top.equalTo(followButton.snp.bottom).offset(20)
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
  
  private func bindViewModel() {
    guard let viewModel = viewModel else { return }
    
    profileImageView.kf.setImage(with: viewModel.profileImageURL)
    fullnameLabel.text = viewModel.fullname
    nicknameLabel.text = viewModel.nickname
    followersBtn.setAttributedTitle(viewModel.numberOfFollowers, for: .normal)
    followingBtn.setAttributedTitle(viewModel.numberOfFollowing, for: .normal)
    followButton.setTitle(viewModel.followButtonText, for: .normal)
    followButton.backgroundColor = viewModel.followButtonBackgroundColor
    followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
    bioLabel.text = viewModel.bio
  }
}

// MARK: - EditProfileControllerDelegte

extension ProfileController: EditProfileControllerDelegte {
  func didUpdateProfile(_ controller: EditProfileController) {
    controller.dismiss(animated: true, completion: nil)
    
    guard let uid = try? keychain.get("uid") else {
      fatalError("DEBUG: Failed to fetch keychain with error")
    }
    
    let request = FetchUserRequest(uid: uid)
    
    UserService.fetchUser(request: request) { response in
      guard let user = response.value?.data else { return }
      self.viewModel = ProfileViewModel(user: user)
    }
  }
}
