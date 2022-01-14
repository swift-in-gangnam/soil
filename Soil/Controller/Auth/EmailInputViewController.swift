//
//  EmailInputViewController.swift
//  soilTest
//
//  Created by 임영선 on 2021/11/08.
//

import UIKit
import Firebase

class EmailInputController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var nextButton: UIButton!
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    emailTextField.addBottomBorderWithColor(color: .black, height: 2.0)
  }
  
  // MARK: - Methods
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @IBAction func didTabNext(_ sender: UIButton) {
    guard let email = emailTextField.text else { return }
    let authUser = AuthUser.shared
    authUser.email = email
  }
}
