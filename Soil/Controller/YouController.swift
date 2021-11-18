//
//  YouController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/03.
//

import UIKit

import Firebase
import Parchment
import SnapKit

class YouController: UIViewController {
  
  // MARK: - Properties
  
  private var user: User
  private let menuArr = ["profile", "day", "month", "year"]
  
  private let pagingVC: PagingViewController = {
    let vc = PagingViewController()
    vc.menuBackgroundColor = .soilBackgroundColor
    vc.menuItemSize = .selfSizing(estimatedWidth: 37, height: 43)
    vc.menuHorizontalAlignment = .center
    vc.menuItemSpacing = 15
    vc.menuItemLabelSpacing = 3
    vc.menuInteraction = .none
    vc.indicatorOptions = .visible(
      height: 2.2,
      zIndex: Int.max,
      spacing: UIEdgeInsets.zero,
      insets: UIEdgeInsets.zero
    )
    vc.indicatorColor = .black
    vc.font = UIFont.montserrat(size: 20, family: .medium)
    vc.selectedFont = UIFont.montserrat(size: 20, family: .medium)
    vc.textColor = .systemGray
    vc.selectedTextColor = .black
    return vc
  }()
  
  // MARK: - Lifecycle
  
  init(user: User) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }

  // MARK: - Actions
  
  @objc private func handleLogout() {
    do {
      try Auth.auth().signOut()
      let controller = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
      //controller.delegate = self.tabBarController as? TabBarController
      let nav = UINavigationController(rootViewController: controller)
      nav.modalPresentationStyle = .fullScreen
      self.present(nav, animated: true, completion: nil)
    } catch {
      print("DEBUG: Failed to Sign out")
    }
  }
  
  // MARK: - Helpers
  
  func configure() {
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
}

// MARK: - PagingViewControllerDataSource

extension YouController: PagingViewControllerDataSource {
  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
    return menuArr.count
  }
  
  func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    if index == 0 {
      let profileVC = ProfileController()
      profileVC.viewModel = ProfileViewModel(user: user)
      profileVC.delegate = self
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
