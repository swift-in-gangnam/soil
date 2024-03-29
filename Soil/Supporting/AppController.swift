//
//  AppController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2022/01/05.
//

import UIKit

import Firebase

final class AppController {
  
  // MARK: - Properties
  
  static let shared = AppController()
  private var window: UIWindow!
  
  private var rootViewController: UIViewController? {
    didSet {
      window.rootViewController = rootViewController
      // transition animation
      UIView.transition(
        with: window,
        duration: 0.5,
        options: [.curveLinear],
        animations: nil,
        completion: nil
      )
    }
  }
  
  // MARK: - Lifecycle
  
  private init() {
    registerAuthStateDidChangeEvent()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Helpers
  
  func show(in window: UIWindow) {
    self.window = window
    window.makeKeyAndVisible()
    checkLogin()
   
  }
  
  private func registerAuthStateDidChangeEvent() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(checkLogin),
      name: .loginStateDidChange, // 서버 로그인 체크
      object: nil
    )
  }
  
  @objc private func checkLogin() {
    let isSignIn = UserDefaults.standard.bool(forKey: "isSignIn") == true
    if isSignIn { 
      setHome()
    } else {
      routeToLogin()
    }
  }
  
  private func setHome() {
    rootViewController = TabBarController(notificationService: NotificationService())
  }
  
  private func routeToLogin() {
    let loginHomeVC = LoginHomeController()
    rootViewController = UINavigationController(rootViewController: loginHomeVC)
  }
}
