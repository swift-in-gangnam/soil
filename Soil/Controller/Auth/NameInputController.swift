//
//  NameInputViewController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/12.
//

import UIKit

class NameInputController: UIViewController {

  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var nameCheckLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    nameTextField.addBottomBorderWithColor(color: .black, height: 2.0)
    nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
  }
  @objc func textFieldDidChange(_ sender: Any?) {
    nameCheckLabel.text = ""
    guard let name = nameTextField.text else { return }
    if validName(name: name) == false {
      nameCheckLabel.textColor = .red
      nameCheckLabel.text = "이름은 최대 15자 입력 가능합니다."
    }
  }
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @IBAction func didTabNext(_ sender: UIButton) {
    guard let name = nameTextField.text else { return }
    
    if name.isEmpty == true {
      nameCheckLabel.textColor = .red
      nameCheckLabel.text = "이름을 입력해주세요."
    } else if validName(name: name) { // 15자 이하인지 체크
      nameCheckLabel.text = ""
      let authUser = AuthUser.shared
      authUser.name = name
      
      guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "profileInputVC") else { return }
      self.navigationController?.pushViewController(vc, animated: true)
    } else {
      nameCheckLabel.textColor = .red
      nameCheckLabel.text = "이름은 최대 15자 입력 가능합니다."
    }
  }
  
  // 이름 15자 제한
  func validName(name: String) -> Bool {
    if name.count > 15 {
      return false
    } else {
      return true
    }
  }
}
