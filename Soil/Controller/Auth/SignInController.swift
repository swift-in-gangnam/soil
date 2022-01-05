//
//  LoginController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/16.
//

import UIKit
import Firebase
import KeychainAccess

class SignInController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var loginCheckLabel: UILabel!
  
  private var viewModel = LoginViewModel()
  private let keychain = Keychain(service: "com.swift-in-gangnam.Soil")
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    emailTextField.addBottomBorderWithColor(color: .black, height: 2.0)
    passwordTextField.addBottomBorderWithColor(color: .black, height: 2.0)
  }

  // MARK: - Actions
  
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @IBAction func didTapLogin(_ sender: Any) {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    AuthService.logUserIn(withEmail: email, password: password) { [weak self] (_, error) in
      if let error = error {
        print("DEBUG: Failed to log user in \(error.localizedDescription)")
        self?.loginCheckLabel.text = "아이디 또는 비밀번호가 틀렸습니다."
        return
      }
      self?.loginCheckLabel.text = " "
    }
  }
  
}
