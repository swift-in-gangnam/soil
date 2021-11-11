//
//  RegistrationController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/04.
//

import UIKit

class RegistrationController: UIViewController {
  
  // MARK: - Properties
  
  private var viewModel = RegistrationViewModel()
  private var profileImage: UIImage?
  weak var delegate: AuthenticationDelegate?
  
  private lazy var plusPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "PlusButton"), for: .normal)
    button.tintColor = .black
    button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
    return button
  }()
  
  private let emailTextField: AuthTextField = {
    let tf = AuthTextField(placeholder: "아이디 입력")
    tf.keyboardType = .emailAddress
    return tf
  }()
  
  private let passwordTextField: AuthTextField = {
    let tf = AuthTextField(placeholder: "비밀번호 입력")
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private let fullnameTextField = AuthTextField(placeholder: "이름 입력")
  
  private let usernameTextField = AuthTextField(placeholder: "닉네임 입력")
  
  private lazy var signUpButton: AuthButton = {
    let button = AuthButton(title: "회원가입", type: .system)
    button.addTarget(self, action: #selector(didTapSignup), for: .touchUpInside)
    return button
  }()
  
  private let cancelButton: UIButton = {
    let button = UIButton(type: .system)
    let attr: [NSAttributedString.Key: Any] = [.font: UIFont.notoSansKR(size: 17, family: .bold),
                                               .foregroundColor: UIColor.black]
    button.setAttributedTitle(NSAttributedString(string: "취소", attributes: attr),
                              for: .normal)
    return button
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureSignupButton()
  }
  
  // MARK: - Actions
  
  @objc func handleProfilePhotoSelect() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
  }
  
  // MARK: - Helpers
  
  private func configureUI() {
    view.backgroundColor = .white
    
    view.addSubview(plusPhotoButton)
    plusPhotoButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.width.equalTo(140)
      make.height.equalTo(140)
      make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
    }
    
    let stackView = UIStackView(arrangedSubviews:
     [emailTextField, passwordTextField,
      fullnameTextField, usernameTextField,
      signUpButton]
    )
    stackView.axis = .vertical
    stackView.spacing = 20
    
    view.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.top.equalTo(plusPhotoButton.snp.bottom).offset(32)
      make.leading.trailing.equalToSuperview().inset(32)
    }
    
    view.addSubview(cancelButton)
    cancelButton.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.leading.trailing.bottom.equalToSuperview().inset(32)
    }
  }
  
  private func configureSignupButton() {
    cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
  }
  
  func configureNotificationObservers() {
    emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
  }
  
  // MARK: - Actions
  
  @objc func textDidChange(sender: UITextField) {
    if sender == emailTextField {
      viewModel.email = sender.text
    } else if sender == passwordTextField {
      viewModel.password = sender.text
    } else if sender == fullnameTextField {
      viewModel.fullname = sender.text
    } else {
      viewModel.username = sender.text
    }
    updateForm()
  }
  
  @objc private func didTapSignup() {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    guard let fullname = fullnameTextField.text else { return }
    guard let username = usernameTextField.text?.lowercased() else { return }
    guard let profileImage = self.profileImage else { return }
    
    let credentials = AuthCredentials.init(
      email: email, password: password,
      fullname: fullname, username: username,
      profileImage: profileImage)
    
    AuthService.registerUser(withCredential: credentials) { error in
      if let error = error {
        print("DEBUG: Failed to register user \(error.localizedDescription)")
        return
      }
      self.delegate?.authenticationDidComplete()
    }
  }
  
  @objc private func didTapCancel() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - FormViewModel

extension RegistrationController: FormViewModel {
  func updateForm() {
    signUpButton.backgroundColor = viewModel.buttonBackgroundColor
    signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    signUpButton.isEnabled = viewModel.formIsValid
  }
}

// MARK: - UIImagePickerControllerDelegate

// UIImagePickerControllerDelegate을 채택할떄는 UINavigationControllerDelegate도 같이 채택해야 한다.
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    guard let selectedImage = info[.editedImage] as? UIImage else { return }
    profileImage = selectedImage
        
    plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
    plusPhotoButton.layer.masksToBounds = true
    plusPhotoButton.layer.borderColor = UIColor.white.cgColor
    plusPhotoButton.layer.borderWidth = 2
    plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
    self.dismiss(animated: true, completion: nil)
  }
}
