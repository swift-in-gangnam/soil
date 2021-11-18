//
//  CompletedController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/17.
//

import UIKit
import Lottie

class SignUpCompletedController: UIViewController {

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
      
    self.navigationController?.navigationBar.topItem?.title = ""
      
    // lottie 애니메이션뷰 설정
    let animationView = AnimationView(name: "task-completed")
    let x = self.view.center.x - 200
    animationView.frame = CGRect(x: x, y: 180, width: 400, height: 400)
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    animationView.animationSpeed = 0.5
    view.addSubview(animationView)
    animationView.play()

  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
}
