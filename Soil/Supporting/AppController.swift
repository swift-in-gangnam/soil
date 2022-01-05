//
//  AppController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2022/01/05.
//

import UIKit

import Firebase
import KeychainAccess

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
  
  private let keychain = Keychain(service: "com.swift-in-gangnam.Soil")
  
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
      
      // idToken, uid를 Keychain에 저장
      user.getIDToken { [weak self] idToken, error in
        if let error = error {
          print("DEBUG: Failed to fetch idToken with error \(error.localizedDescription)")
          return
        }
        do {
          try self?.keychain.set(String(describing: idToken), key: "token")
          try self?.keychain.set(String(describing: user.uid), key: "uid")
        } catch let error {
          fatalError("DEBUG: Failed to add keychain with error \(error.localizedDescription)")
        }
      }
      setHome()
    } else {
      // keychain 비우기
      do {
        try keychain.removeAll()
      } catch let error {
        fatalError("DEBUG: Failed to remove keychain with error \(error.localizedDescription)")
      }
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
