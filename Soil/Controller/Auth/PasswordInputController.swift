//
//  PasswordInputViewController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/12.
//

import UIKit

class PasswordInputController: UIViewController {

  // Properties
  @IBOutlet weak var passwordCheckLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  
  // LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    
    passwordTextField.addBottomBorderWithColor(color: .black, height: 2.0)
    passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
  }
  
  // Methods
  // 비밀번호 규칙에 틀리면 textColor red로, 맞으면 green으로 변경
  @objc func textFieldDidChange(_ sender: Any?) {
    passwordCheckLabel.text = "숫자와 문자를 포함하여 8자 이상 입력해주세요."
    guard let password = passwordTextField.text else { return }
    
    if validpassword(password: password) {
      passwordCheckLabel.textColor = .systemGreen
    } else {
      passwordCheckLabel.textColor = .red
    }
  }
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @IBAction func didTabNext(_ sender: UIButton) {
    guard let password = passwordTextField.text else { return }
  
    if password.isEmpty == true {
      passwordCheckLabel.textColor = .red
      passwordCheckLabel.text = "비밀번호를 입력해주세요."
    } else if validpassword(password: password) { // 비밀번호 규칙에 준수하는지 체크
      passwordCheckLabel.textColor = UIColor(named: "AAAAAA")
      let authUser = AuthUser.shared
      authUser.password = password
      
      guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "nicknameVC") else { return }
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  // 숫자+문자 포함해서 8~20글자 사이의 text 체크하는 정규표현식
  func validpassword(password: String) -> Bool {
    let passwordreg = ("(?=.*[A-Za-z])(?=.*[0-9]).{8,20}")
    let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
    return passwordtesting.evaluate(with: password)
  }
}
