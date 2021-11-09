//
//  SceneDelegate.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/02.
//

import UIKit
import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let scene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: scene)
    window?.rootViewController = TabBarController()
//    window?.rootViewController = LoginController()
    window?.makeKeyAndVisible()
    configureIQKeyboardManager()
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {}
  
  func sceneDidBecomeActive(_ scene: UIScene) {}
  
  func sceneWillResignActive(_ scene: UIScene) {}
  
  func sceneWillEnterForeground(_ scene: UIScene) {}
  
  func sceneDidEnterBackground(_ scene: UIScene) {}
  
  func configureIQKeyboardManager() {
      IQKeyboardManager.shared.enable = true
      IQKeyboardManager.shared.enableAutoToolbar = true
      IQKeyboardManager.shared.shouldResignOnTouchOutside = true
  }
}
