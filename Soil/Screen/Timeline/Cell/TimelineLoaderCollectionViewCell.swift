//
//  TimelineLoaderCollectionViewCell.swift
//  Soil
//
//  Created by dykoon on 2022/05/03.
//

import UIKit

final class TimelineLoaderCollectionViewCell: UICollectionViewCell {

  // MARK: - Property

  let activityIndicatorView = UIActivityIndicatorView(style: .medium).then {
    $0.tintColor = .systemGray2
    $0.hidesWhenStopped = true
  }
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Method
  
  func startAnimating() {
    activityIndicatorView.startAnimating()
  }
  
  func stopAnimating() {
    activityIndicatorView.stopAnimating()
  }
  
  func configureUI() {
    contentView.addSubview(activityIndicatorView)
    activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
