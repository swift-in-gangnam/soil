//
//  AuthButton.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/04.
//

import UIKit

class AuthButton: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setTitleColor(.white, for: .normal)
    backgroundColor = .black
    layer.cornerRadius = 5
    snp.makeConstraints { make in
      make.height.equalTo(50)
    }
  }
  
  convenience init(title: String, type: UIButton.ButtonType) {
    self.init(type: type)
    setTitle(title, for: .normal)
    titleLabel?.font = UIFont.notoSansKR(size: 20, family: .bold)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
