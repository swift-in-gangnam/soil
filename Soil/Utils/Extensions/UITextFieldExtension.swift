//
//  UITextFieldExtension.swift
//  Soil
//
//  Created by dykoon on 2021/11/23.
//

import UIKit

extension UITextField {
  func addBottomBorderWithColor(color: UIColor, spacing: CGFloat = 10, height: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(
      x: 0,
      y: self.frame.size.height - height + spacing,
      width: self.frame.size.width,
      height: height
    )
    self.layer.addSublayer(border)
  }
}
