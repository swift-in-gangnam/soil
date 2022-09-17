//
//  EditProfileController.swift
//  Soil
//
//  Created by dykoon on 2021/11/14.
//

import UIKit

import Alamofire

protocol EditProfileControllerDelegte: AnyObject {
    func didUpdateProfile(_ controller: EditProfileController)
}

final class EditProfileController: UIViewController {
  
  // MARK: - Properties
    
  var viewModel: ProfileViewModel? {
    didSet { bindViewModel() }
  }
  
  weak var delegate: EditProfileControllerDelegte?
  
  private var selectedProfileImage: UIImage? {
    didSet {
      profileImageView.image = selectedProfileImage
    }
  }
  
  private var isDeletedProfileImage = false
  
  private let barButtonAttrs: [NSAttributedString.Key: Any] = [
    .font: UIFont.montserrat(size: 16, family: .medium)
  ]
  
  private lazy var cancelButton = UIBarButtonItem().then {
    $0.title = "Cancel"
    $0.setTitleTextAttributes(barButtonAttrs, for: .normal)
    $0.setTitleTextAttributes(barButtonAttrs, for: .highlighted)
    $0.target = self
    $0.action = #selector(didTapCancel)
  }
  
  private lazy var doneButton = UIBarButtonItem().then {
    $0.title = "Done"
    $0.setTitleTextAttributes(barButtonAttrs, for: .normal)
    $0.setTitleTextAttributes(barButtonAttrs, for: .highlighted)
    $0.target = self
    $0.action = #selector(didTapDone)
  }
  
  private let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.backgroundColor = .systemGray3
    $0.snp.makeConstraints { make in
      make.width.height.equalTo(100)
    }
    $0.layer.cornerRadius = 100 / 2
  }
  
  private lazy var imageChangeBtn = UIButton(type: .system).then {
    $0.setTitle("change profile image", for: .normal)
    $0.titleLabel?.font = UIFont.ceraPro(size: 15, family: .medium)
    $0.setTitleColor(.systemBlue, for: .normal)
    $0.addTarget(self, action: #selector(didTapImageChangeBtn), for: .touchUpInside)
  }
  
  private let nameLabel = UILabel().then {
    $0.text = "Name"
    $0.font = UIFont.ceraPro(size: 15, family: .medium)
  }
  
  private lazy var nameTextField = UITextField().then {
    $0.placeholder = "이름을 입력해주세요."
    $0.font = UIFont.ceraPro(size: 15, family: .bold)
    $0.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
  }
  
  private let nameCountLabel = UILabel().then {
    $0.textColor = .systemGray2
    $0.font = UIFont.ceraPro(size: 13, family: .medium)
  }
  
  private let bioLabel = UILabel().then {
    $0.text = "Bio"
    $0.font = UIFont.ceraPro(size: 15, family: .medium)
  }
  
  private let bioStackView = UIStackView().then {
    $0.backgroundColor = .soilBackgroundColor
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fill
    $0.spacing = 0
  }
  
  private lazy var bioTextView = UITextView().then {
    $0.font = UIFont.ceraPro(size: 15, family: .bold)
    $0.backgroundColor = .soilBackgroundColor
    $0.isScrollEnabled = false
    $0.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    $0.delegate = self
  }
  
  private var isOversized = false {
    didSet {
      guard oldValue != isOversized else {
        return
      }
      bioTextView.isScrollEnabled = isOversized
      bioTextView.setNeedsUpdateConstraints()
    }
  }
  
  private let underLine = UIView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.systemGray3.cgColor
  }
  
  private let bioCountLabel = UILabel().then {
    $0.textColor = .systemGray2
    $0.font = UIFont.ceraPro(size: 13, family: .medium)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .soilBackgroundColor
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.tintColor = .black
    navigationItem.title = "edit profile"
    navigationItem.leftBarButtonItem = cancelButton
    navigationItem.rightBarButtonItem = doneButton
    layoutSubviews()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    nameTextField.addBottomBorderWithColor(color: .systemGray3, spacing: 4, height: 1.0)
  }
  
  // MARK: - Action
  
  @objc func didTapCancel() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func didTapDone() {
    guard let name = nameTextField.text,
          let bio = bioTextView.text,
          let viewModel = viewModel
    else { return }
    
    var isDeleteParameter = false
    
    // 기존에 사진이 있으면서, 삭제하는 경우 `isDelete` 파라미터 true로
    if viewModel.profileImageURL?.absoluteString != "empty",
       self.isDeletedProfileImage == true {
        isDeleteParameter = true
    }
    
    let request = UpdateUserRequest(
      name: name,
      bio: bio,
      file: selectedProfileImage?.jpegData(compressionQuality: 0.75),
      isDelete: isDeleteParameter
    )
        
    UserService.updateUser(request: request) { response in
      switch response.result {
      case .success:
        self.delegate?.didUpdateProfile(self)
      case .failure(let error):
        print("DEBUG: Failed to update user with error \(error.localizedDescription)")
      }
    }
  }

  @objc func didTapImageChangeBtn() {
    AlertBuilder(viewController: self)
      .preferredStyle(.actionSheet)
      .onDefaultAction(title: "사진 가져오기") {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
      }
      .onDestructiveAction(title: "현재 사진 삭제") {
        self.selectedProfileImage = nil
        self.isDeletedProfileImage = true
      }
      .onCancelAction(title: "취소")
      .show()
  }
  
  @objc func textDidChange(sender: UITextField) {
    checkFullnameMaxLength(sender)
    nameCountLabel.text = "\(sender.text?.count ?? 0) / 15"
  }
  
  // MARK: - Helpers
  
  private func layoutSubviews() {
    view.addSubview(profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(5)
      make.centerX.equalTo(self.view.snp.centerX)
    }
    
    view.addSubview(imageChangeBtn)
    imageChangeBtn.snp.makeConstraints { make in
      make.top.equalTo(profileImageView.snp.bottom).offset(10)
      make.centerX.equalTo(self.view.snp.centerX)
    }
    
    let divider = UIView()
    view.addSubview(divider)
    divider.backgroundColor = .systemGray3
    divider.snp.makeConstraints { make in
      make.top.equalTo(imageChangeBtn.snp.bottom).offset(15)
      make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
      make.height.equalTo(1)
    }
    
    view.addSubview(nameLabel)
    nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    nameLabel.snp.makeConstraints { make in
      make.top.equalTo(divider.snp.bottom).offset(30)
      make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
    }
    
    view.addSubview(nameTextField)
    nameTextField.snp.makeConstraints { make in
      make.leading.equalTo(nameLabel.snp.trailing).offset(15)
      make.bottom.equalTo(nameLabel.snp.bottom)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
    }
    
    view.addSubview(nameCountLabel)
    nameCountLabel.snp.makeConstraints { make in
      make.top.equalTo(nameTextField.snp.bottom).offset(10)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-12)
    }
    
    view.addSubview(bioLabel)
    bioLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    bioLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    bioLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom).offset(53)
      make.leading.equalTo(nameLabel.snp.leading)
    }
    
    view.addSubview(bioStackView)
    bioStackView.addArrangedSubview(bioTextView)
    bioStackView.addArrangedSubview(underLine)
    bioStackView.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom).offset(53)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
      make.width.equalTo(nameTextField.snp.width)
      make.height.lessThanOrEqualTo(130)
    }
    bioTextView.snp.makeConstraints { make in
      make.width.equalToSuperview()
    }
    underLine.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(1)
    }
    
    view.addSubview(bioCountLabel)
    bioCountLabel.snp.makeConstraints { make in
      make.top.equalTo(underLine.snp.bottom).offset(7)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-12)
    }
  }
  
  private func bindViewModel() {
    guard let viewModel = viewModel else { return }
    
    profileImageView.kf.setImage(with: viewModel.profileImageURL)
    nameTextField.text = viewModel.fullname
    nameCountLabel.text = viewModel.fullnameCount
    bioTextView.text = viewModel.bio
    bioCountLabel.text = viewModel.bioCount
  }
  
  private func checkFullnameMaxLength(_ textField: UITextField) {
    if (textField.text?.count ?? 0) > 15 {
      textField.deleteBackward()
    }
  }
  
  private func checkBioMaxLength(_ textView: UITextView) {
    if (textView.text.count) > 255 {
      textView.deleteBackward()
    }
  }
}

// MARK: - UITextViewDelegate

extension EditProfileController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    checkBioMaxLength(textView)
    bioCountLabel.text = "\(textView.text.count) / 255"
    isOversized = textView.contentSize.height >= 129
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.contentSize.height >= 129 {
      textView.isScrollEnabled = true
    }
  }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    guard let selectedImage = info[.editedImage] as? UIImage else { return }
    selectedProfileImage = selectedImage
    self.isDeletedProfileImage = false
    self.dismiss(animated: true, completion: nil)
  }
}
