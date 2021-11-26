//
//  NickNameInputViewController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/12.
//

import UIKit

class NickNameInputController: UIViewController {

  @IBOutlet weak var nickNameTextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    nickNameTextField.addBottomBorderWithColor(color: .black, height: 2.0)
  }
  
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }

}
