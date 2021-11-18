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

  private func createCustomPasswordTextField() {
   // delegate = self
    eyeButton = UIButton()
    eyeButton.contentMode = .scaleAspectFit
    eyeButton.setImage(UIImage(named: "eye"), for: .normal)
    self.rightView = eyeButton
    self.rightViewMode = .always
    self.leftViewMode = .never
    
    let buttonLine = CALayer()
    buttonLine.frame = CGRect(x: 0, y: self.frame.height-2, width: self.frame.width, height: 2)
    buttonLine.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    self.borderStyle = .none
    self.layer.addSublayer(buttonLine)
  }
}
