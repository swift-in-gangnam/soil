//
//  NameInputViewController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/12.
//

import UIKit

class NameInputController: UIViewController {

  @IBOutlet weak var nameTextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    nameTextField.addBottomBorderWithColor(color: .black, height: 2.0)
  }
  
  @IBAction func tapView(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
}
