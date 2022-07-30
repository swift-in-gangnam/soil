//
//  TabBarController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/02.
//

import UIKit

import KeychainAccess
import Kingfisher
import SnapKit
import Then

final class TabBarController: UITabBarController {
  
  // MARK: - Properties
  
  private let notificationService: NotificationService
  private let keychain = Keychain(service: "com.chuncheonian.Soil")
  
  private let uploadController = UploadPostController().then {
    $0.tabBarItem.image = UIImage(named: "PlusButton")!.withRenderingMode(.alwaysOriginal)
    $0.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
  }
  
  // MARK: - Lifecycle
  
  init(notificationService: NotificationService) {
    self.notificationService = notificationService
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewControllers()
    notificationService.requestNotificationAuthorization()
  }
  
  // MARK: - Helpers
    
  private func configureViewControllers() {
    view.backgroundColor = .white
    tabBar.tintColor = .black
    self.delegate = self

    let tabBarAppearance = UITabBarAppearance()
    tabBarAppearance.configureWithDefaultBackground()
    tabBarAppearance.backgroundColor = .soilBackgroundColor
    tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
      .font: UIFont.montserrat(size: 23, family: .medium)
    ]
    tabBarAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -14)
    self.tabBar.standardAppearance = tabBarAppearance
    self.tabBar.scrollEdgeAppearance = tabBarAppearance
    
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.configureWithDefaultBackground()
    navigationBarAppearance.backgroundColor = .soilBackgroundColor
    navigationBarAppearance.shadowColor = .soilBackgroundColor
    navigationBarAppearance.largeTitleTextAttributes = [
      NSAttributedString.Key.font: UIFont.montserrat(size: 35, family: .bold)
    ]
    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
    let feedNavController = templateNavigationController(title: "feed", rootVC: FeedController())
    let youNavController = templateNavigationController(title: "you", rootVC: YouController(uid: nil))
  
    viewControllers = [feedNavController, uploadController, youNavController]
  }
  
  func templateNavigationController(title: String, rootVC: UIViewController) -> UINavigationController {
    let nav = UINavigationController(rootViewController: rootVC)
    nav.tabBarItem.title = title
    nav.navigationBar.tintColor = .black
    return nav
  }
}

// MARK: - UITabBarController Delegate

extension TabBarController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    let isModalView = viewController is UploadPostController
    
    if isModalView {
      let vc = UploadPostController()
      vc.modalPresentationStyle = .fullScreen
      self.present(vc, animated: true, completion: nil)
      return false
    }
    
    return true
  }
}
