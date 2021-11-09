//
//  TabBarController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/02.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
  
  // MARK: - Properties
  
  var user: User? {
    didSet {
      configurController()
      configureTabBar()
    }
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkIfUserIsLoggedIn()
    fetchUser()
  }
  
  // MARK: - API
  
  func checkIfUserIsLoggedIn() {
    if Auth.auth().currentUser == nil {
      DispatchQueue.main.async {
        let controller = LoginController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
      }
    }
  }
    
  func fetchUser() {
    UserService.fetchUser { user in
      self.user = user
    }
  }
  
  // MARK: - Helpers
  
  private func configurController() {
    view.backgroundColor = .white
    self.delegate = self
  }
  
  private func configureTabBar() {
    tabBar.tintColor = .black
    // Tab Bar의 모습을 iOS 15 이전 처럼 하기 위해 추가.
    let tabBarAppearance = UITabBar.appearance()
    tabBarAppearance.isTranslucent = false
    tabBarAppearance.barTintColor = UIColor.soilBackgroundColor
    tabBarAppearance.backgroundColor = UIColor.soilBackgroundColor
    
    let feedNavController = initNavController(
      ofType: FeedController.self,
      title: "feed",
      tabBarFont: UIFont.montserrat(size: 25, family: .medium),
      navBarFont: UIFont.montserrat(size: 25, family: .bold)
    )
    
    let dummyVC = NewPostController()
    dummyVC.tabBarItem.image = UIImage(named: "PlusButton")!.withRenderingMode(.alwaysOriginal)
    dummyVC.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
    
    let youNavController = initNavController(
      ofType: YouController.self,
      title: "you",
      tabBarFont: UIFont.montserrat(size: 25, family: .medium),
      navBarFont: UIFont.montserrat(size: 25, family: .bold)
    )
    
    viewControllers = [feedNavController, dummyVC, youNavController]
  }
  
  private func initNavController<T: UIViewController>(
    ofType: T.Type,
    title: String,
    tabBarFont: UIFont,
    navBarFont: UIFont
  ) -> UINavigationController {
    
    let vc = T.init()
    vc.navigationItem.title = title
    let navController = UINavigationController(rootViewController: vc)
    navController.tabBarItem.title = title
    navController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: tabBarFont], for: .normal)
    navController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -14)
    // Navigation Bar의 모습을 iOS 15 이전 처럼 하기 위해 추가.
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = UIColor.soilBackgroundColor
    navController.navigationBar.standardAppearance = appearance
    navController.navigationBar.scrollEdgeAppearance = appearance
    // backbutton 색깔 .black으로 설정.
    navController.navigationBar.tintColor = UIColor.black
    // largeTitles 켜기.
    navController.navigationBar.prefersLargeTitles = true
    navController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: navBarFont]
    return navController
  }
}

// MARK: - UITabBarController Delegate

extension TabBarController: UITabBarControllerDelegate {
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    let isModalView = viewController is NewPostController
    
    if isModalView {
      let vc = NewPostController()
      self.present(vc, animated: true, completion: nil)
      return false
    }
    
    return true
  }
}

// MARK: - AuthenticationDelegate

extension TabBarController: AuthenticationDelegate {
  func authenticationDidComplete() {
    fetchUser()
    self.dismiss(animated: true, completion: nil)
  }
}
