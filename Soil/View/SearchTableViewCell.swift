//
//  SearchTableViewCell.swift
//  Soil
//
//  Created by 임영선 on 2022/04/13.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  
  static let identifier = "SearchTableViewCell"
  
  let label = UILabel().then {
    $0.text = "test"
    $0.textAlignment = .center
    $0.font = UIFont.notoSansKR(size: 16, family: .regular)
    $0.textColor = .black
  }
  
  let xButton = UIButton().then {
    $0.setImage(UIImage(named: "xButton"), for: .normal)
  }
  
  // MARK: - Methods
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setConstraint()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  private func setConstraint() {
    contentView.addSubview(label)
    label.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(21)
    }
    
    contentView.addSubview(xButton)
    xButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-21)
    }
  }
}
