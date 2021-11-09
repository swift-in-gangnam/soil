//
//  YouController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/03.
//

import UIKit
import Firebase

class YouController: UIViewController {
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .cyan
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "person.fill.xmark"),
      style: .plain,
      target: self,
      action: #selector(handleLogout)
    )
  }

  // MARK: - Actions
  
  @objc private func handleLogout() {
    do {
      try Auth.auth().signOut()
      let controller = LoginController()
      controller.delegate = self.tabBarController as? TabBarController
      let nav = UINavigationController(rootViewController: controller)
      nav.modalPresentationStyle = .fullScreen
      self.present(nav, animated: true, completion: nil)
    } catch {
      print("DEBUG: Failed to Sign out")
    }
  }
  
}
