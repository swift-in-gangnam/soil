//
//  CustomPasswordTextField.swift
//  Soil
//
//  Created by 임영선 on 2021/11/16.
//
import UIKit

class CustomPasswordTextField: UITextField {
  
  enum CurrentPasswordInputStatus {
    case invalidPassword
    case validPassword
  }
  
  private var eyeButton: UIButton!
  private var passwordInputStatus: CurrentPasswordInputStatus = .invalidPassword
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    createCustomPasswordTextField()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    createCustomPasswordTextField()
  }

  // show 버튼 rightView에 생성
  private func createCustomPasswordTextField() {
    eyeButton = UIButton()
    eyeButton.contentMode = .scaleAspectFit
    eyeButton.setTitle("show", for: .normal)
    eyeButton.setTitleColor(UIColor(named: "AAAAAA"), for: .normal)
    
    eyeButton.setTitle("show", for: .selected)
    eyeButton.setTitleColor(.black, for: .selected)
    
    eyeButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
    
    self.rightView = eyeButton
    self.rightViewMode = .always
    self.leftViewMode = .never
  }
  
  @objc func togglePasswordView(_ sender: UIButton) {
    isSecureTextEntry.toggle()
    sender.isSelected.toggle()
  }
}
