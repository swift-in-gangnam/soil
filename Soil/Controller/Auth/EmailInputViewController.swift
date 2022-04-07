//
//  EmailInputViewController.swift
//  soilTest
//
//  Created by 임영선 on 2021/11/08.
//

import UIKit
import Firebase
import Alamofire

class EmailInputController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var emailCheckLabel: UILabel!
  
  // MARK: LifeCycle
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    emailTextField.addBottomBorderWithColor(color: .black, height: 2.0)
    emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    
    // 이메일 인증 체크 NotificationCenter 등록
    NotificationCenter.default.addObserver(
      self, selector: #selector(emailAuthSuccess),
      name: .emailAuthStateDidChange, object: nil
    )
  }
  
  // MARK: - Methods
  @objc func textFieldDidChange(_ sender: Any?) {
    emailCheckLabel.text = ""
  }
  
  @objc func emailAuthSuccess() {
    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "passwordVC") else { return }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @IBAction func didTabNext(_ sender: UIButton) {
    guard let email = emailTextField.text else { return }
    
    if email.isEmpty == true { // 이메일 입력을 안했을 때
      emailCheckLabel.textColor = .red
      emailCheckLabel.text = "이메일을 입력해주세요."
    } else if validEmail(email: email) { // 이메일 규칙에 준수할 때
      let authUser = AuthUser.shared
      authUser.email = email
      getEmailDup()
    } else { // 이메일 규칙에 어긋날 때
      emailCheckLabel.textColor = .red
      emailCheckLabel.text = "올바른 이메일 형식을 입력해주세요."
    }
  }
  
  // 이메일 정규표현식
  func validEmail(email: String) -> Bool {
    let emailReg = ("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    let emailTesting = NSPredicate(format: "SELF MATCHES %@", emailReg)
    return emailTesting.evaluate(with: email)
  }
  
  // 이메일 중복 체크 API
  func getEmailDup() {
    let email = AuthUser.shared.email
    
    AuthService.getDupEmail(email: email!, completion: { (response) in
      switch response.result {
      case .success(let data):
        print("getDupEmail success")
        do {
          let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
          let json = try JSONDecoder().decode(ResponseAuthUser.self, from: jsonData)
          if json.success { // 중복되지 않은 이메일이면
            self.emailCheckLabel.text = ""
            
            // 인증 이메일 전송
            let actionCodeSettings = ActionCodeSettings()
            if let email = email {
              actionCodeSettings.url = URL(string: "https://soil-6d0b8.firebaseapp.com/?email=\(email)")
              actionCodeSettings.handleCodeInApp = true
              guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return }
              actionCodeSettings.setIOSBundleID(bundleIdentifier)
              
              Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
                if let error = error {
                  print("email not sent \(error.localizedDescription)")
                } else {
                  print("email sent")
                }
              }
            }
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "emailConfirmVC") else { return }
            self.navigationController?.pushViewController(vc, animated: true)
          } else { // 중복된 이메일이면
            self.emailCheckLabel.textColor = .red
            self.emailCheckLabel.text = "중복된 이메일입니다."
          }
        } catch {
          print("DEBUG: Failed to jsonParsing with error")
        }
        
      case .failure(let error):
        print("DEBUG: Failed to getDupEmail with error : \(error.localizedDescription)")
      }
    })
  }
}
