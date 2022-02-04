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
    FirebaseApp.configure()
    registerAuthStateDidChangeEvent()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Helpers
  
  func show(in window: UIWindow) {
    self.window = window
    window.makeKeyAndVisible()
    
    if Auth.auth().currentUser == nil {
      routeToLogin()
    }
  }
  
  private func registerAuthStateDidChangeEvent() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(checkLogin),
      name: .AuthStateDidChange, // <- Firebase Auth 이벤트
      object: nil
    )
  }
  
  @objc private func checkLogin() {
    if let user = Auth.auth().currentUser { // <- Firebase Auth
      print("user = \(user)")
      setHome()
    } else {
      routeToLogin()
    }
  }
  
  private func setHome() {
    rootViewController = TabBarController()
  }
  
  private func routeToLogin() {
    let loginHomeVC = LoginHomeController()
    rootViewController = UINavigationController(rootViewController: loginHomeVC)
  }
}
