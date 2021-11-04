//
//  AuthTextField.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/04.
//

import UIKit
import SnapKit

class AuthTextField: UITextField {
  
  init(placeholder: String) {
    super.init(frame: .zero)
    
    let spacer = UIView()
    spacer.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.width.equalTo(12)
    }
    leftView = spacer
    leftViewMode = .always
    
    borderStyle = .none
    textColor = .white
    keyboardAppearance = .light
    backgroundColor = UIColor.systemGray4
    
    let attr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white,
                                               .font: UIFont.notoSansKR(size: 17, family: .regular)]
    attributedPlaceholder = NSAttributedString(string: placeholder,
                                               attributes: attr)
    snp.makeConstraints { make in
      make.height.equalTo(50)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
