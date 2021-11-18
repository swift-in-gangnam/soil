//
//  LoginController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/04.
//

import UIKit

protocol AuthenticationDelegate: AnyObject {
  func authenticationDidComplete()
}

class LoginController: UIViewController {
  
  // MARK: - Properties
  
  private var viewModel = LoginViewModel()
  
  weak var delegate: AuthenticationDelegate?
  
  private let iconImage: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(named: "SoilIcon")
    iv.contentMode = .scaleAspectFill
    return iv
  }()
  
  private let idTextField: AuthTextField = {
    let tf = AuthTextField(placeholder: "아이디 입력")
    tf.keyboardType = .emailAddress
    return tf
  }()
  
  private let passwordTextField: AuthTextField = {
    let tf = AuthTextField(placeholder: "비밀번호 입력")
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private lazy var loginButton: AuthButton = {
    let button = AuthButton(title: "로그인", type: .system)
    button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    return button
  }()
  
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
    configureNotificationObservers()
  }
  
  // MARK: - Actions
  
  @objc private func textDidChange(sender: UITextField) {
    if sender == idTextField {
      viewModel.email = sender.text
    } else {
      viewModel.password = sender.text
    }
    
    updateForm()
  }
  
  @objc private func didTapLogin() {
    guard let email = idTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    AuthService.logUserIn(withEmail: email, password: password) { (_, error) in
      if let error = error {
        print("DEBUG: Failed to log user in \(error.localizedDescription)")
        return
      }
      
      self.delegate?.authenticationDidComplete()
    }
  }
  
  @objc private func didTapSignup() {
    let vc = RegistrationController()
    vc.delegate = delegate
    navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: - Helpers
  
  private func configureUI() {
    view.backgroundColor = .white
    navigationController?.navigationBar.isHidden = true
    
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
    
  func configureNotificationObservers() {
    idTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
  }
}

// MARK: - FormViewModel
    
extension LoginController: FormViewModel {
  func updateForm() {
    loginButton.backgroundColor = viewModel.buttonBackgroundColor
    loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    loginButton.isEnabled = viewModel.formIsValid
  }
}
