//
//  YouController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/03.
//

import UIKit

import Alamofire
import Firebase
import Parchment
import KeychainAccess

class YouController: UIViewController {
  
  // MARK: - Properties
  
  private let keychain = Keychain(service: "com.chuncheonian.Soil")
  fileprivate var user: User?
  private let menuArr = ["profile", "day", "month", "year"]
  
  private let pagingVC = PagingViewController().then {
    $0.menuBackgroundColor = .soilBackgroundColor
    $0.menuItemSize = .selfSizing(estimatedWidth: 37, height: 43)
    $0.menuHorizontalAlignment = .center
    $0.menuItemSpacing = 15
    $0.menuItemLabelSpacing = 3
    $0.menuInteraction = .none
    $0.indicatorOptions = .visible(
      height: 2.2,
      zIndex: Int.max,
      spacing: UIEdgeInsets.zero,
      insets: UIEdgeInsets.zero
    )
    $0.indicatorColor = .black
    $0.font = UIFont.montserrat(size: 20, family: .medium)
    $0.selectedFont = UIFont.montserrat(size: 20, family: .medium)
    $0.textColor = .systemGray
    $0.selectedTextColor = .black
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    fetchUser()
  }

  // MARK: - Actions
  
  @objc private func handleLogout() {
    do {
      try keychain.removeAll()  // keychain 비우기
      try Auth.auth().signOut()
    } catch let error {
      fatalError("DEBUG: Failed to Sign out with error \(error.localizedDescription)")
    }
  }
  
  // MARK: - Helpers
  
  private func configure() {
    view.backgroundColor = .soilBackgroundColor
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "gearshape"),
      style: .plain,
      target: self,
      action: #selector(handleLogout)
    )
    
    addChild(pagingVC)
    view.addSubview(pagingVC.view)
    pagingVC.didMove(toParent: self)
    pagingVC.view.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
    }
    pagingVC.dataSource = self
  }
  
  private func fetchUser() {

    guard let uid = try? keychain.get("uid") else {
      fatalError("DEBUG: Failed to fetch keychain with error")
    }
    
    let request = FetchUserRequest(uid: uid)

    UserService.fetchUser(request: request) { response in
      guard let user = response.value else { return }
      self.user = user
      self.pagingVC.reloadData()
    }
  }
}

// MARK: - PagingViewControllerDataSource

extension YouController: PagingViewControllerDataSource {
  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
    return menuArr.count
  }
  
  func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    
    if index == 0 {
      let profileVC = ProfileController()
      
      if let user = user {
        profileVC.viewModel = ProfileViewModel(user: user)
        profileVC.delegate = self
      }
      return profileVC
    } else if index == 1 {
      let dayVC = DayController()
      return dayVC
    } else if index == 2 {
      let monthVC = MonthController()
      return monthVC
    } else {
      let yearVC = YearController()
      return yearVC
    }
  }
  
  func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    return PagingIndexItem(index: index, title: menuArr[index])
  }
}

extension YouController: ProfileControllerDelegate {
  func didTapUserStatBtn() {
    navigationController?.pushViewController(UserStatController(), animated: true)
  }
}
