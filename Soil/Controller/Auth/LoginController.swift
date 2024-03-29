//
//  LoginController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/16.
//

import UIKit

import Alamofire
import Firebase
import FirebaseMessaging
import KeychainAccess

final class LoginController: UIViewController {
  
  // MARK: - outlet
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: CustomPasswordTextField!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var loginCheckLabel: UILabel!
  
  // MARK: - property
  
  private let keychain = Keychain(service: "com.chuncheonian.Soil")
  
  // MARK: - life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    emailTextField.addBottomBorderWithColor(color: .black, height: 2.0)
    passwordTextField.addBottomBorderWithColor(color: .black, height: 2.0)
    
    stackView.setCustomSpacing(50, after: emailTextField)
  }

  // MARK: - action
  
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @IBAction func didTapLogin(_ sender: Any) {
    guard let email = emailTextField.text,
          let password = passwordTextField.text
    else { return }
    
    if email.isEmpty || password.isEmpty {
      loginCheckLabel.text = "아이디 또는 비밀번호를 입력해주세요."
      return
    }
    
    AuthService.firebaseLogin(withEmail: email, password: password) { [weak self] (result, error) in
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
        
        guard let fcmtoken = Messaging.messaging().fcmToken else {
          print("DEBUG: Failed to fetch fcm token")
          return
        }
        
        let request = LoginRequest(fcmToken: fcmtoken)

        AuthService.login(request: request, completion: { response in
          switch response.result {
          case .success:
            print("login succeess")
            UserDefaults.standard.set(true, forKey: "isSignIn")
            NotificationCenter.default.post(name: .loginStateDidChange, object: nil)
          case .failure:
            print("login failure")
          }
        })
        
      })
      
      self?.loginCheckLabel.text = " "
    }
  }
}
