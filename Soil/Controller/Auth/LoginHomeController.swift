//
//  ViewController.swift
//  soilTest
//
//  Created by 임영선 on 2021/11/08.
//

import UIKit

class LoginHomeController: UIViewController {

  // MARK: - Properties
    @IBOutlet weak var chineseLabel: UILabel!
    @IBOutlet weak var soilExplanationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chineseLabel.alpha = 0
        soilExplanationLabel.alpha = 0
        UIView.animate(withDuration: 2.0, animations: ({
            self.chineseLabel.alpha  = 1
            self.soilExplanationLabel.alpha = 1
        }))
    }

  // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
