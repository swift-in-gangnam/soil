//
//  CompletedController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/17.
//

import UIKit
import Lottie

class SignUpCompletedController: UIViewController {
  // MARK: - Properties
  let animationView = AnimationView()

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    setUpAnimation()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
    animationView.play()
  }
  
  // MARK: - Methods
  func setUpAnimation() {
    animationView.animation = Animation.named("70170-success-check")
    let x = self.view.center.x - 150
    let y = self.view.center.y - 170
    animationView.frame = CGRect(x: x, y: y, width: 300, height: 300)
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    animationView.animationSpeed = 0.5
    view.addSubview(animationView)
  }
}
