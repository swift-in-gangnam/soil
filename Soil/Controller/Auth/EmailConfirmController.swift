//
//  EmailConfirmController.swift
//  soilTest
//
//  Created by 임영선 on 2021/11/08.
//

import UIKit
import Lottie

class EmailConfirmController: UIViewController {
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
    animationView.play()
  }
  
  // MARK: - Methods
  func setUpAnimation() {
    animationView.animation = Animation.named("20425-emailtitle")
    let x = self.view.center.x - 100
    let y = self.view.center.y - 200
    animationView.frame = CGRect(x: x, y: y, width: 200, height: 200)
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    animationView.animationSpeed = 0.4
    view.addSubview(animationView)
  }
}
