//
//  LoginController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/16.
//

import UIKit
import Firebase
import Alamofire
import KeychainAccess

class SignInController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var loginCheckLabel: UILabel!
  @IBOutlet weak var stackView: UIStackView!
  
  private var viewModel = LoginViewModel()
  
  private let keychain = Keychain(service: "com.chuncheonian.Soil")
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    emailTextField.addBottomBorderWithColor(color: .black, height: 2.0)
    passwordTextField.addBottomBorderWithColor(color: .black, height: 2.0)
    
    stackView.setCustomSpacing(50, after: emailTextField)
  }

  // MARK: - Actions
  
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @IBAction func didTapLogin(_ sender: Any) {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    if email.isEmpty || password.isEmpty {
      loginCheckLabel.text = "아이디 또는 비밀번호를 입력해주세요."
      return
    }
    
    AuthService.logUserIn(withEmail: email, password: password) { [weak self] (result, error) in
      if let error = error {
        print("DEBUG: Failed to log user in \(error.localizedDescription)")
        self?.loginCheckLabel.text = "아이디 또는 비밀번호가 틀렸습니다."
        return
      }
      
      guard let result = result else { return }
      
      // idToken, uid를 Keychain에 저장
      result.user.getIDToken(completion: { idToken, error in
        if let error = error {
          print("DEBUG: Failed to fetch idToken with error \(error.localizedDescription)")
          return
        }
        
        guard let idToken = idToken else { return }
        print("token - \(idToken)")
        
        do {
          try self?.keychain.set(idToken, key: "token")
          try self?.keychain.set(result.user.uid, key: "uid")
        } catch let error {
          fatalError("DEBUG: Failed to add keychain with error \(error.localizedDescription)")
        }
        
        let request = LoginRequest(fcmToken: "xxx")
        
        AFManager
          .shared
          .session
          .request(UserRouter.loginUser(request))
          .validate(statusCode: 200..<401)
          .validate(contentType: ["application/json"])
          .responseJSON { response in
            debugPrint(response)
          }
      })
      
      self?.loginCheckLabel.text = " "
    }
  }
}
