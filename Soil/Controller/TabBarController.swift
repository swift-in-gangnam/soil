//
//  TabBarController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/02.
//

import UIKit

import Firebase
import SnapKit
import Then

class TabBarController: UITabBarController {
  
  // MARK: - Properties
  
  var user: User? {
    didSet {
      guard let user = user else { return }
      configureViewControllers(withUser: user)
    }
  }
  
  private let uploadController: UploadPostController = {
    let controller = UploadPostController()
    controller.tabBarItem.image = UIImage(named: "PlusButton")!.withRenderingMode(.alwaysOriginal)
    controller.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
    return controller
  }()
  
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
        let controller = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        //controller.delegate = self
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
    
  private func configureViewControllers(withUser user: User) {
    view.backgroundColor = .white
    tabBar.tintColor = .black
    self.delegate = self

    if #available(iOS 13.0, *) {
      let tabBarAppearance = UITabBarAppearance()
      tabBarAppearance.configureWithDefaultBackground()
      tabBarAppearance.backgroundColor = .soilBackgroundColor
      tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
        NSAttributedString.Key.font: UIFont.montserrat(size: 23, family: .medium)
      ]
      tabBarAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -14)
      self.tabBar.standardAppearance = tabBarAppearance
      
      if #available(iOS 15.0, *) {
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
      }
    }
    
    if #available(iOS 13.0, *) {
      let navigationBarAppearance = UINavigationBarAppearance()
      navigationBarAppearance.configureWithDefaultBackground()
      navigationBarAppearance.backgroundColor = .soilBackgroundColor
      navigationBarAppearance.shadowColor = .soilBackgroundColor
      navigationBarAppearance.largeTitleTextAttributes = [
        NSAttributedString.Key.font: UIFont.montserrat(size: 35, family: .bold)
      ]
      UINavigationBar.appearance().standardAppearance = navigationBarAppearance
      UINavigationBar.appearance().compactAppearance = navigationBarAppearance
      
      if #available(iOS 15.0, *) {
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
      }
    }
        
    let feedNavController = templateNavigationController(title: "feed", rootVC: FeedController())
    let youNavController = templateNavigationController(title: "you", rootVC: YouController(user: user))
  
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

// MARK: - AuthenticationDelegate

extension TabBarController: AuthenticationDelegate {
  func authenticationDidComplete() {
    fetchUser()
    self.dismiss(animated: true, completion: nil)
  }
}
