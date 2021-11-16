//
//  HorizontalSeperator.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/16.
//

import Foundation
import UIKit

class HorizontalSeperator: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .systemGray3
    snp.makeConstraints { make in
      make.height.equalTo(1)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
