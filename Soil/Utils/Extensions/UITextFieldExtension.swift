//
//  UITextFieldExtension.swift
//  Soil
//
//  Created by dykoon on 2021/11/23.
//

import UIKit

extension UITextField {
  func addBottomBorderWithColor(color: UIColor, height: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(
      x: 0,
      y: self.frame.size.height - height + 10,
      width: self.frame.size.width,
      height: height
    )
    self.layer.addSublayer(border)
  }
}
