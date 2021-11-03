//
//  FeedController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/03.
//

import UIKit

class FeedController: UIViewController {
  
  // MARK: - Properties
  private let pushButton: UIButton = {
    let button = UIButton()
    button.setTitle("push", for: .normal)
    return button
  }()
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .green
    view.addSubview(pushButton)
    pushButton.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    pushButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }
  
  // MARK: - Actions
  @objc private func didTapButton() {
    let vc = UIViewController()
    vc.view.backgroundColor = .brown
    navigationController?.pushViewController(vc, animated: true)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
