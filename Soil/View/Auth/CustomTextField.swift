//
//  CustomTextField.swift
//  Soil
//
//  Created by 임영선 on 2021/11/16.
//

import UIKit

class CustomTextField: UITextField {
  override init(frame: CGRect) {
    super.init(frame: frame)
    createCustomTextField()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    createCustomTextField()
  }

  private func createCustomTextField() {
    let buttonLine = CALayer()
    buttonLine.frame = CGRect(x: 0, y: self.frame.height-2, width: self.frame.width, height: 2)
    buttonLine.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    self.borderStyle = .none
    self.layer.addSublayer(buttonLine)
  }
}
