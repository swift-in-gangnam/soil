//
//  EmailConfirmController.swift
//  soilTest
//
//  Created by 임영선 on 2021/11/08.
//

import UIKit
import Lottie
import Firebase

class EmailConfirmController: UIViewController {
  // MARK: - Properties
  let animationView = AnimationView()
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var confirmLabel: UILabel!
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    emailLabel.text = AuthUser.shared.email
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
  
  // 인증 이메일 전송
  @IBAction func didTabSendEmail(_ sender: Any) {
    let email = AuthUser.shared.email
    let actionCodeSettings = ActionCodeSettings()
    if let email = email {
      actionCodeSettings.url = URL(string: "https://soil-6d0b8.firebaseapp.com/?email=\(email)")
      actionCodeSettings.handleCodeInApp = true
      guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return }
      actionCodeSettings.setIOSBundleID(bundleIdentifier)
      
      Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
        if let error = error {
          print("email not sent \(error.localizedDescription)")
        } else {
          self.confirmLabel.text = "이메일을 다시 전송했어요."
        }
      }
    }
  }
  
}
