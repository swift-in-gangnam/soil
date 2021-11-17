//
//  PasswordInputViewController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/12.
//

import UIKit

class PasswordInputController: UIViewController {

  @IBOutlet weak var passwordTextField: UITextField!
  override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = ""
    }
  
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
}
