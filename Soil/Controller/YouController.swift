//
//  YouController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/03.
//

import UIKit
import Firebase

class YouController: UIViewController {
  
  // MARK: - Properties
  
  private var user: User
  
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
      let controller = LoginController()
      controller.delegate = self.tabBarController as? TabBarController
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
  }
  
}
