//
//  NewPostController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/03.
//

import UIKit
import SnapKit

class NewPostController: UIViewController {
  
  // MARK: - Properties
  private let cancelButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .cyan
    button.setTitle("cancel", for: .normal)
    button.sizeToFit()
    return button
  }()
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .orange
    view.addSubview(cancelButton)
    cancelButton.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    cancelButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }
  
  // MARK: - Actions
  @objc private func didTapButton() {
    self.dismiss(animated: true, completion: nil)
  }
}
