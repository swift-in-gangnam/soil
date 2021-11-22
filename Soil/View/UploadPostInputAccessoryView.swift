//
//  UploadPostInputAccessoryView.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/16.
//

import UIKit

protocol UploadPostInputAccessoryViewDelegate: AnyObject {
  func selectPhoto()
  func selectMusic()
  func selectClose()
}

class UploadPostInputAccessoryView: UIView {
  
  // MARK: - Properties
  
  weak var delegate: UploadPostInputAccessoryViewDelegate?
  
  private let addPhotoButton = UIButton(type: .system).then {
    $0.setImage(UIImage(systemName: "camera.fill"), for: .normal)
    $0.tintColor = .black
    $0.snp.makeConstraints { make in
      make.width.height.equalTo(30)
    }
    $0.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
  }
  
  private let addMusicButton = UIButton(type: .system).then {
    $0.setImage(UIImage(systemName: "headphones"), for: .normal)
    $0.tintColor = .black
    $0.snp.makeConstraints { make in
      make.width.height.equalTo(30)
    }
    $0.addTarget(self, action: #selector(addMusicTapped), for: .touchUpInside)
  }
  
  let closeButton = UIButton(type: .system).then {
    let attrs: [NSAttributedString.Key: Any] = [
      .font: UIFont.montserrat(size: 16, family: .semiBold),
      .foregroundColor: UIColor.black
    ]
    $0.setAttributedTitle(
      NSAttributedString(string: "Close", attributes: attrs),
      for: .normal
    )
    $0.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    $0.isHidden = true
  }
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .soilBackgroundColor
    autoresizingMask = .flexibleHeight
    
    let seperator = HorizontalSeperator()
    addSubview(seperator)
    seperator.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }
    
    addSubview(addPhotoButton)
    addPhotoButton.snp.makeConstraints { make in
      make.top.equalTo(seperator.snp.bottom).offset(12)
      make.leading.equalToSuperview().offset(30)
      make.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
    }
    
    addSubview(addMusicButton)
    addMusicButton.snp.makeConstraints { make in
      make.leading.equalTo(addPhotoButton.snp.trailing).offset(20)
      make.centerY.equalTo(addPhotoButton)
    }
    
    addSubview(closeButton)
    closeButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-30)
      make.centerY.equalTo(addPhotoButton)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    let contentHeight: CGFloat = addPhotoButton.intrinsicContentSize.height + 16
    return CGSize(width: UIScreen.main.bounds.width, height: contentHeight)
  }
  
  // MARK: - Actions
  
  @objc private func addPhotoTapped() {
    self.delegate?.selectPhoto()
  }
  
  @objc private func addMusicTapped() {
    self.delegate?.selectMusic()
  }
  
  @objc private func closeTapped() {
    self.delegate?.selectClose()
  }
}
