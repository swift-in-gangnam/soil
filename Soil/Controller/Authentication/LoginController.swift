//
//  LoginController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/04.
//

import UIKit
import SnapKit

class LoginController: UIViewController {
  
  // MARK: - Properties
  private let iconImage: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(named: "SoilIcon")
    iv.contentMode = .scaleAspectFill
    return iv
  }()
  
  private let idTextField: UITextField = AuthTextField(placeholder: "아이디 입력")
  
  private let passwordTextField: UITextField = {
    let tf = AuthTextField(placeholder: "비밀번호 입력")
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private let loginButton = AuthButton(title: "로그인", type: .system)
  
  private let signupButton: UIButton = {
    let button = UIButton(type: .system)
    let attr: [NSAttributedString.Key: Any] = [.font: UIFont.notoSansKR(size: 17, family: .bold),
                                               .foregroundColor: UIColor.black]
    button.setAttributedTitle(NSAttributedString(string: "회원가입", attributes: attr),
                              for: .normal)
    return button
  }()
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    configureSignupButton()
  }
  
  // MARK: - Helpers
  
  private func configureUI() {
    view.backgroundColor = .white
    
    view.addSubview(iconImage)
    iconImage.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.width.equalTo(140)
      make.height.equalTo(90)
      make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
    }
    
    let stackView = UIStackView(arrangedSubviews: [idTextField, passwordTextField, loginButton])
    stackView.axis = .vertical
    stackView.spacing = 20
    
    view.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.top.equalTo(iconImage.snp.bottom).offset(32)
      make.leading.trailing.equalToSuperview().inset(32)
    }
    
    view.addSubview(signupButton)
    signupButton.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.leading.trailing.bottom.equalToSuperview().inset(32)
    }
  }
  
  private func configureSignupButton() {
    signupButton.addTarget(self, action: #selector(didTapSignup), for: .touchUpInside)
  }
  
  // MARK: - Actions
  
  @objc private func didTapSignup() {
    let vc = RegistrationController()
    present(vc, animated: true, completion: nil)
  }
}
