//
//  TagCell.swift
//  Soil
//
//  Created by 임영선 on 2022/05/18.
//

import UIKit
import MapKit

class TagCell: UITableViewCell {
  
  // MARK: - Properties
  
  private let tagView = UIView().then {
    $0.snp.makeConstraints { make in
      make.width.height.equalTo(50)
    }
    $0.layer.cornerRadius = 50 / 2
    $0.backgroundColor = .black
  }
  
  private let tagViewLabel = UILabel().then {
    $0.text = "#"
    $0.font = UIFont.ceraPro(size: 35, family: .bold)
    $0.textColor = .white
  }
  
  let tagLabel = UILabel().then {
    $0.font = UIFont.ceraPro(size: 16, family: .bold)
    $0.textColor = .black
  }
  
  let tagCountLabel = UILabel().then {
    $0.font = UIFont.notoSansKR(size: 11, family: .regular)
    $0.textColor = .systemGray
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    backgroundColor = .soilBackgroundColor
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(tagView)
    tagView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(21)
    }
    
    tagView.addSubview(tagViewLabel)
    tagViewLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    let stack = UIStackView(arrangedSubviews: [tagLabel, tagCountLabel])
    stack.axis = .vertical
    stack.spacing = 2
    stack.alignment = .leading
    
    addSubview(stack)
    stack.snp.makeConstraints { make in
      make.centerY.equalToSuperview().offset(5)
      make.leading.equalTo(self.tagView.safeAreaLayoutGuide.snp.trailing).offset(12)
    }
  }
}
