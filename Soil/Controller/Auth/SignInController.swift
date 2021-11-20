//
//  LoginController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/16.
//

import UIKit

protocol AuthDelegate: AnyObject {
  func authenticationDidComplete()
}

class SignInController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var emailTextField: CustomTextField!
  @IBOutlet weak var passwordTextField: CustomTextField!
  @IBOutlet weak var loginButton: UIButton!
  
  private var viewModel = LoginViewModel()
  weak var delegate: AuthenticationDelegate?
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
  }

  // MARK: - Actions
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @IBAction func didTapLogin(_ sender: Any) {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    AuthService.logUserIn(withEmail: email, password: password) { (_, error) in
      if let error = error {
        print("DEBUG: Failed to log user in \(error.localizedDescription)")
        return
      }
      
      self.delegate?.authenticationDidComplete()
      let controller = TabBarController()
      controller.modalPresentationStyle = .fullScreen
      self.present(controller, animated: true, completion: nil)
    }
  }
  
}
