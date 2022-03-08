//
//  UserCell.swift
//  Soil
//
//  Created by dykoon on 2022/01/25.
//

import UIKit

class UserCell: UITableViewCell {
  
  // MARK: - Properties
  
  var viewModel: UserCellViewModel? {
    didSet { bindViewModel() }
  }
  
  private let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.backgroundColor = .lightGray
    $0.snp.makeConstraints { make in
      make.width.height.equalTo(50)
    }
    $0.layer.cornerRadius = 50 / 2
  }
  
  private let nicknameLabel = UILabel().then {
    $0.font = UIFont.ceraPro(size: 14, family: .bold)
    $0.textColor = .black
  }
  
  private let nameLabel = UILabel().then {
    $0.font = UIFont.notoSansKR(size: 14, family: .regular)
    $0.textColor = .systemGray
  }
  
  // MARK: - Lifecycle
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.backgroundColor = .soilBackgroundColor
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helpers
  
  private func configureUI() {
    addSubview(profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(21)
    }
    
    let stack = UIStackView(arrangedSubviews: [nicknameLabel, nameLabel])
    stack.axis = .vertical
    stack.spacing = 2
    stack.alignment = .leading
    
    addSubview(stack)
    stack.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(self.profileImageView.safeAreaLayoutGuide.snp.trailing).offset(12)
    }
  }
  
  private func bindViewModel() {
    guard let viewModel = viewModel else { return }
    
    profileImageView.kf.setImage(with: viewModel.profileImageURL)
    nicknameLabel.text = viewModel.nickname
    nameLabel.text = viewModel.name
  }
}
