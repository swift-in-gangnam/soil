//
//  EmailConfirmController.swift
//  soilTest
//
//  Created by 임영선 on 2021/11/08.
//

import UIKit
import Lottie

class EmailConfirmController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationController?.navigationBar.topItem?.title = ""
        
    // lottie 애니메이션뷰 설정
    let animationView = AnimationView(name: "email-sent")
    let x = self.view.center.x - 200
    animationView.frame = CGRect(x: x, y: 50, width: 400, height: 400)
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    animationView.animationSpeed = 0.4
    view.addSubview(animationView)
    animationView.play()
  }
}
