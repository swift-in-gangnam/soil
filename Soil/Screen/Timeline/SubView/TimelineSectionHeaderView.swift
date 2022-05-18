//
//  TimelineSectionHeaderView.swift
//  Soil
//
//  Created by dykoon on 2022/05/03.
//

import UIKit

final class TimelineSectionHeaderView: UICollectionReusableView {
  
  // MARK: - Properties
  
  let label = UILabel().then {
    $0.font = UIFont.ceraPro(size: 27, family: .medium)
    $0.textColor = .systemGray2
  }
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Method
  
  private func configureUI() {
    addSubview(label)
    label.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview()
    }
  }
}
