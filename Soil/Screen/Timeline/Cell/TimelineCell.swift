//
//  TimelineCell.swift
//  Soil
//
//  Created by dykoon on 2022/05/02.
//

import UIKit

final class TimelineCell: UICollectionViewCell {
  
  // MARK: - Properties
    
  let titleLabel = UILabel().then {
    $0.font = UIFont.ceraPro(size: 30, family: .medium)
    $0.textColor = .black
  }
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .white
    contentView.layer.cornerRadius = 15
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Method
  
  private func configureUI() {
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(27)
    }
  }
}
