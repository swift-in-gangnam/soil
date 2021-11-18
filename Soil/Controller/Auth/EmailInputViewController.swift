//
//  EmailInputViewController.swift
//  soilTest
//
//  Created by 임영선 on 2021/11/08.
//

import UIKit

class EmailInputController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
  }
  
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
}
