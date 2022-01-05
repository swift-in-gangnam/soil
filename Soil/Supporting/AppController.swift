//
//  AppController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2022/01/05.
//

import UIKit
import Firebase

final class AppController {
  
  static let shared = AppController()
  
  private init() {
    FirebaseApp.configure()
    registerAuthStateDidChangeEvent()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
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
  
  func show(in window: UIWindow) {
    self.window = window
    window.backgroundColor = .systemBackground
    window.makeKeyAndVisible()
    
    checkLogin()
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
    let loginHomeVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "homeVC")
    rootViewController = UINavigationController(rootViewController: loginHomeVC)
  }
}