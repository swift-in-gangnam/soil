//
//  ProfileController.swift
//  Soil
//
//  Created by dykoon on 2021/11/11.
//

import UIKit

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
  
  weak var delegate: ProfileControllerDelegate?
  
  var viewModel: ProfileViewModel? {
    didSet { bindViewModel() }
  }
  
  private let scrollView = UIScrollView()
  
  private let refreshControl = UIRefreshControl()
  
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
    handlePullToRefresh()
  }
  
  // MARK: - Action
  
  @objc func refreshUser() {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      guard let viewModel = self.viewModel else { return }

      let request = FetchUserRequest(uid: viewModel.uid)
      
      UserService.fetchUser(request: request) { response in
        guard let user = response.value?.data else { return }
        self.viewModel = ProfileViewModel(user: user)
      }
      self.refreshControl.endRefreshing()
    }
  }
  
  @objc func handleFollowButtonTapped() {
    guard let viewModel = viewModel else { return }
    
    switch viewModel.type {
    case 1:  // Edit Profile
      let controller = EditProfileController()
      controller.viewModel = ProfileViewModel(user: viewModel.user)
      controller.delegate = self
      let nav = UINavigationController(rootViewController: controller)
      nav.modalPresentationStyle = .fullScreen
      self.present(nav, animated: true, completion: nil)
    case 2:  // Unfollow User
      let request = UnfollowUserRequest(unfollowUID: viewModel.uid)
      FollowService.unfollowUser(request: request) { response in
        guard let user = response.value?.data else { return }
        self.viewModel = ProfileViewModel(user: user)
      }
    case 3:  // Follow User
      let request = FollowUserRequest(followingUID: viewModel.uid)
      FollowService.followUser(request: request) { response in
        guard let user = response.value?.data else { return }
        self.viewModel = ProfileViewModel(user: user)
      }
    default:
      print("DEBUG: Not Exist User's Type")
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
    
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.width.height.equalToSuperview()
      make.center.equalToSuperview()
    }
    
    scrollView.addSubview(profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.top.equalTo(self.scrollView.snp.top).offset(24)
      make.width.height.equalTo(100)
      make.centerX.equalToSuperview()
    }
    
    scrollView.addSubview(fullnameLabel)
    fullnameLabel.snp.makeConstraints { make in
      make.top.equalTo(self.profileImageView.snp.bottom).offset(15)
      make.centerX.equalToSuperview()
    }
    
    scrollView.addSubview(nicknameLabel)
    nicknameLabel.snp.makeConstraints { make in
      make.top.equalTo(self.fullnameLabel.snp.bottom).offset(4)
      make.centerX.equalToSuperview()
    }
    
    let userStatDivider = UIView()
    scrollView.addSubview(userStatDivider)
    userStatDivider.snp.makeConstraints { make in
      make.top.equalTo(self.nicknameLabel.snp.bottom).offset(11)
      make.centerX.equalToSuperview()
      make.height.equalTo(30)
      make.width.equalTo(1)
    }
    userStatDivider.backgroundColor = .systemGray3
    
    scrollView.addSubview(followersBtn)
    followersBtn.snp.makeConstraints { make in
      make.trailing.equalTo(userStatDivider.snp.leading).offset(-20)
      make.centerY.equalTo(userStatDivider.snp.centerY)
    }
    
    scrollView.addSubview(followingBtn)
    followingBtn.snp.makeConstraints { make in
      make.leading.equalTo(userStatDivider.snp.trailing).offset(20)
      make.centerY.equalTo(userStatDivider.snp.centerY)
    }
    
    scrollView.addSubview(followButton)
    followButton.snp.makeConstraints { make in
      make.top.equalTo(userStatDivider.snp.bottom).offset(12)
      make.centerX.equalToSuperview()
      make.width.equalTo(150)
      make.height.equalTo(40)
    }
    
    let divider = UIView()
    scrollView.addSubview(divider)
    divider.snp.makeConstraints { make in
      make.top.equalTo(followButton.snp.bottom).offset(20)
      make.leading.equalTo(self.scrollView.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(self.scrollView.safeAreaLayoutGuide.snp.trailing)
      make.height.equalTo(1)
    }
    divider.backgroundColor = .systemGray3
    
    scrollView.addSubview(bioLabel)
    bioLabel.snp.makeConstraints { make in
      make.top.equalTo(divider.snp.bottom).offset(20)
      make.leading.equalTo(self.scrollView.safeAreaLayoutGuide.snp.leading).offset(16)
      make.bottom.equalTo(self.scrollView.snp.bottom)
      make.trailing.equalTo(self.scrollView.safeAreaLayoutGuide.snp.trailing).offset(-16)
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
  
  private func handlePullToRefresh() {
    refreshControl.addTarget(self, action: #selector(refreshUser), for: .valueChanged)
    scrollView.refreshControl = refreshControl
  }
}

// MARK: - EditProfileControllerDelegte

extension ProfileController: EditProfileControllerDelegte {
  func didUpdateProfile(_ controller: EditProfileController) {
    controller.dismiss(animated: true, completion: nil)
    
    guard let viewModel = viewModel else { return }
    let request = FetchUserRequest(uid: viewModel.uid)
    
    UserService.fetchUser(request: request) { response in
      guard let user = response.value?.data else { return }
      self.viewModel = ProfileViewModel(user: user)
    }
  }
}
