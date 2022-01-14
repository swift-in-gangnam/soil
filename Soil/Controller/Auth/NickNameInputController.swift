//
//  NickNameInputViewController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/12.
//

import UIKit

class NickNameInputController: UIViewController {

  @IBOutlet weak var nicknameCheckLabel: UILabel!
  @IBOutlet weak var nickNameTextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    
    nickNameTextField.text = "@"
    nickNameTextField.addBottomBorderWithColor(color: .black, height: 2.0)
    nickNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
  }
  
  // Methods
 
  @objc func textFieldDidChange(_ sender: Any?) {
    nicknameCheckLabel.textColor = .red
    nicknameCheckLabel.text = "5자 이상 15자 이하의 영문 또는 숫자를 입력해주세요."
    
    if nickNameTextField.text?.isEmpty == true { // 앞에 @ 붙임
      nickNameTextField.text = "@"
    }
    
    guard var nickname = nickNameTextField.text else { return }
    nickname = String(nickname.dropFirst()) // @ 제거
    if validNickname(nickname: nickname) {
      nicknameCheckLabel.textColor = .systemGreen
    } else {
      nicknameCheckLabel.textColor = .red
    }
  }
  // (?=.*[a-zA-Z]{2,50})
  // 영문으로만 5~15글자 사이의 text 체크하는 정규표현식
  func validNickname(nickname: String) -> Bool {
    let nicknameReg = "[A-Za-z0-9]{5,15}"
    let nicknameTesting = NSPredicate(format: "SELF MATCHES %@", nicknameReg)
    return nicknameTesting.evaluate(with: nickname)
  }
  
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @IBAction func didTabNext(_ sender: Any) {
    guard var nickname = nickNameTextField.text else { return }
    nickname = String(nickname.dropFirst()) // @ 제거
    
    if nickname.isEmpty == true { // 닉네임 입력을 안했을 때
      nicknameCheckLabel.textColor = .red
      nicknameCheckLabel.text = "닉네임을 입력해주세요."
    } else if validNickname(nickname: nickname) { // 닉네임 규칙에 준수할 때
      nicknameCheckLabel.textColor = UIColor(named: "AAAAAA")
      let authUser = AuthUser.shared
      authUser.nickname = nickname
      print("nickname :\(authUser.nickname!)")
      
      guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "nameVC") else { return }
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
}
