//
//  UploadPostController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/03.
//

import UIKit
import Tags

enum UploadPostError: Error, LocalizedError {
  case emptyTitle
  
  var errorDescription: String? {
    switch self {
    case .emptyTitle:
      return "일기 제목이 비었습니다"
    }
  }
}

class UploadPostController: UIViewController {
  
  // MARK: - Properties
  
  private let textViewPlaceholder = "나만의 소중한 일상을 기록해보세요"
  
  private lazy var imagePicker = UIImagePickerController().then {
    $0.sourceType = .photoLibrary
    $0.allowsEditing = true
    $0.delegate = self
  }
  
  private let titleButtonAttributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.montserrat(size: 16, family: .medium),
    .foregroundColor: UIColor.black
  ]
  
  private lazy var cancelButton = UIBarButtonItem().then {
    $0.title = "Cancel"
    $0.setTitleTextAttributes(titleButtonAttributes, for: .normal)
    $0.setTitleTextAttributes(titleButtonAttributes, for: .highlighted)
    $0.target = self
    $0.action = #selector(didTapCancel)
  }
  
  private lazy var writeButton = UIBarButtonItem().then {
    $0.title = "Write"
    $0.setTitleTextAttributes(titleButtonAttributes, for: .normal)
    $0.setTitleTextAttributes(titleButtonAttributes, for: .highlighted)
    $0.target = self
    $0.action = #selector(didTapWrite)
  }
  
  private let scrollView = UIScrollView().then {
    $0.keyboardDismissMode = .interactive
  }
  
  private lazy var titleTextField = UITextField().then {
    $0.delegate = self
    $0.placeholder = "제목"
    var attributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.notoSansKR(size: 25, family: .regular),
      .foregroundColor: UIColor.systemGray3
    ]
    $0.attributedPlaceholder = NSAttributedString(
      string: "제목",
      attributes: attributes
    )
    attributes[.foregroundColor] = UIColor.black
    $0.defaultTextAttributes = attributes
    
    let spacer = UIView()
    let height: CGFloat = 60
    spacer.snp.makeConstraints { make in
      make.height.equalTo(height)
      make.width.equalTo(20)
    }
    $0.leftView = spacer
    $0.leftViewMode = .always
    
    $0.snp.makeConstraints { make in
      make.height.equalTo(height)
    }
  }
  
  private lazy var isSecretButton = UIButton(type: .custom).then {
    $0.setImage(UIImage(systemName: "square"), for: .normal)
    $0.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
    $0.setImage(UIImage(systemName: "checkmark.square"), for: .highlighted)
    $0.setTitle("비밀일기로 쓰기", for: .normal)
    $0.setTitleColor(.darkGray, for: .normal)
    $0.tintColor = .darkGray
    $0.addTarget(self, action: #selector(didTapIsSecretButton), for: .touchUpInside)
  }
  
  private let tagsView = TagsView()
  
  private let contentTextView = UITextView().then {
    $0.backgroundColor = .soilBackgroundColor
    $0.isScrollEnabled = false
  }
  
  private lazy var customInputAccessoryView = UploadPostInputAccessoryView().then {
    $0.delegate = self
  }
  
  private let imageView = UIImageView().then {
    $0.backgroundColor = .green
    $0.clipsToBounds = true
    $0.contentMode = .scaleAspectFill
    $0.snp.makeConstraints { make in
      make.height.equalTo(0)
    }
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .soilBackgroundColor
    configureUI()
    configureTagsView()
    configureContentTextView()
    configureImageView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    resignFirstResponder()
  }
  
  override var inputAccessoryView: UIView? {
    return customInputAccessoryView
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
}

// MARK: - Functions

extension UploadPostController {
  
  // MARK: - Helpers
  
  private func getPostUploadDataFromSelf() throws -> PostUploadRequest {
    guard let title = titleTextField.text, !title.isEmpty else {
      throw UploadPostError.emptyTitle
    }
    
    let content: String
    
    if contentTextView.textColor == .lightGray {
      content = ""
    } else {
      content = contentTextView.text
    }
    
    let imageData = imageView.image?.jpegData(compressionQuality: 0.9)
    
    let isSecret = isSecretButton.isSelected
    let tags: [String] = tagsView.tagTextArray.map { originalString in
      var updatedString = originalString
      updatedString.removeFirst()
      return updatedString
    }
    
    let song = "Muse - Hysteria"
          
    let data = PostUploadRequest(
      title: title,
      isSecret: isSecret,
      tags: tags,
      content: content,
      imageData: imageData,
      song: song
    )
    
    return data
  }
  
  private func configureUI() {
    
    // MARK: - Configure Navigation Bar
    
    let naviBar = UINavigationBar(frame: CGRect(
      x: 0,
      y: 0,
      width: view.frame.width,
      height: 44)
    )
    naviBar.isTranslucent = false
    naviBar.backgroundColor = UIColor.soilBackgroundColor
    
    let naviItem = UINavigationItem(title: "")
    naviItem.leftBarButtonItem = cancelButton
    naviItem.rightBarButtonItem = writeButton
    
    naviBar.items = [naviItem]
    
    view.addSubview(naviBar)
    
    naviBar.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    // MARK: - Configure rest of UI
    
    let seperator1 = HorizontalSeperator()
    view.addSubview(seperator1)
    seperator1.snp.makeConstraints { make in
      make.top.equalTo(naviBar.snp.bottom)
      make.leading.trailing.equalToSuperview()
    }
    
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(seperator1.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    let contentsView = UIView()
    scrollView.addSubview(contentsView)
    contentsView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalTo(view.frame.width)
      //      make.height.equalTo(view.frame.height + 100)
    }
    
    contentsView.addSubview(titleTextField)
    titleTextField.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview()
    }
    
    let seperator2 = HorizontalSeperator()
    contentsView.addSubview(seperator2)
    seperator2.snp.makeConstraints { make in
      make.top.equalTo(titleTextField.snp.bottom)
      make.leading.trailing.equalToSuperview()
    }
    
    contentsView.addSubview(isSecretButton)
    isSecretButton.snp.makeConstraints { make in
      make.top.equalTo(seperator2.snp.bottom).offset(20)
      make.leading.equalToSuperview().offset(20)
    }
    
    contentsView.addSubview(tagsView)
    tagsView.snp.makeConstraints { make in
      make.top.equalTo(isSecretButton.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview().inset(20)
    }
    
    let seperator3 = HorizontalSeperator()
    contentsView.addSubview(seperator3)
    seperator3.snp.makeConstraints { make in
      make.top.equalTo(tagsView.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview()
    }
    
    contentsView.addSubview(contentTextView)
    contentTextView.snp.makeConstraints { make in
      make.top.equalTo(seperator3.snp.bottom).offset(40)
      make.leading.trailing.equalToSuperview().inset(30)
      make.height.greaterThanOrEqualTo(200)
      make.bottom.lessThanOrEqualToSuperview() // imageView의 height가 0일 경우 대비
    }
    
    contentsView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.equalTo(contentTextView.snp.bottom).offset(100)
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.lessThanOrEqualToSuperview().offset(-70)
    }
  }
  
  private func configureTagsView() {
    tagsView.delegate = self
    
    tagsView.paddingHorizontal = 8
    tagsView.paddingVertical = 3
    tagsView.marginHorizontal = 10
    tagsView.marginVertical = 5
    
    tagsView.tagLayerRadius = 16
    tagsView.tagLayerWidth = 0
    tagsView.tagTitleColor = .black
    tagsView.tagBackgroundColor = .white
    tagsView.tagFont = .notoSansKR(size: 16, family: .regular)
    tagsView.lineBreakMode = .byTruncatingMiddle
    
    tagsView.lastTag = "+ 태그" // "        +        "
    tagsView.lastTagTitleColor = .black
    tagsView.lastTagBackgroundColor = .white
  }
  
  private func configureContentTextView() {
    contentTextView.delegate = self
    let text = "나만의 소중한 일상을 기록해보세요"
    let attributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.notoSansKR(size: 15, family: .regular),
      .foregroundColor: UIColor.lightGray
    ]
    contentTextView.attributedText = NSAttributedString(string: text, attributes: attributes)
  }
  
  private func configureImageView() {
    let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
    imageView.addGestureRecognizer(tapGR)
    imageView.isUserInteractionEnabled = true
  }
  
  private func showAlert(title: String?, message: String?) {
    AlertBuilder(viewController: self)
      .title(title)
      .message(message)
      .preferredStyle(.alert)
      .onDefaultAction(title: "확인")
      .show()
  }
  
  // MARK: - Actions
  
  @objc private func didTapCancel() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc private func didTapWrite() {
    print("DEBUG: write Tapped...")
    do {
      let data = try getPostUploadDataFromSelf()
      PostService.uploadPost(data: data) { [weak self] response in
        switch response.result {
        case .success(let data):
          if let data = data {
            print(String(data: data, encoding: .utf8) ?? "")
          }
          self?.dismiss(animated: true, completion: nil)
        case .failure(let error):
          print(error)
        }
      }
    } catch UploadPostError.emptyTitle {
      showAlert(title: "오류 발생", message: UploadPostError.emptyTitle.errorDescription)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  @objc private func didTapIsSecretButton() {
    isSecretButton.isSelected.toggle()
  }
  
  @objc private func didTapImageView(gestureRecognizer: UITapGestureRecognizer) {
    let cancelAction = {
      let action = UIAlertAction(title: "취소", style: .cancel, handler: nil)
      action.setValue(UIColor.black, forKey: "titleTextColor")
      return action
    }()
    
    let deleteAction = {
      let action = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
        self?.imageView.snp.updateConstraints { make in
          make.height.equalTo(0)
        }
      }
      action.setValue(UIColor.black, forKey: "titleTextColor")
      return action
    }()
    
    AlertBuilder(viewController: self)
      .message("이미지를 삭제하시겠어요?")
      .preferredStyle(.alert)
      .onAction(cancelAction)
      .onAction(deleteAction)
      .show()
  }
}

// MARK: - UITextViewDelegate

extension UploadPostController: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    customInputAccessoryView.closeButton.isHidden = false
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.notoSansKR(size: 15, family: .regular),
        .foregroundColor: UIColor.black
      ]
      textView.typingAttributes = attributes
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    customInputAccessoryView.closeButton.isHidden = true
    if textView.text.isEmpty {
      let text = textViewPlaceholder
      let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.notoSansKR(size: 15, family: .regular),
        .foregroundColor: UIColor.lightGray
      ]
      textView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
  }
}

extension UploadPostController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    customInputAccessoryView.closeButton.isHidden = false
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    customInputAccessoryView.closeButton.isHidden = true
  }
}

// MARK: - TagsDelegate

extension UploadPostController: TagsDelegate {
  
  func tagsLastTagAction(_ tagsView: TagsView, tagButton: TagButton) {
    let alertController = UIAlertController(title: nil, message: "태그 추가", preferredStyle: .alert)
    alertController.addTextField { (textField) in
      textField.returnKeyType = .next
      textField.becomeFirstResponder()
    }
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
    let addAction = UIAlertAction(title: "추가", style: .default) { (_) in
      if let text = alertController.textFields?.first?.text, text != "" {
        // append
        self.tagsView.append("#\(text)")
      }
    }
    addAction.setValue(UIColor.black, forKey: "titleTextColor")
    alertController.addAction(cancelAction)
    alertController.addAction(addAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  func tagsTouchAction(_ tagsView: TagsView, tagButton: TagButton) {
    // Update & Delete ActionSheet UIAlertController
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
    alertController.addAction(cancelAction)
    
    let appendAction = UIAlertAction(title: "수정", style: .default) { (_) in
      
      // Update UIAlertController
      let alertController = UIAlertController(title: nil, message: "태그 수정", preferredStyle: .alert)
      alertController.addTextField { (textField) in
        guard let title = tagButton.currentTitle else { return }
        let startIdx = title.index(title.startIndex, offsetBy: 1)
        textField.text = String(title[startIdx...])
      }
      
      let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
      cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
      alertController.addAction(cancelAction)
      
      let appendAction = UIAlertAction(title: "수정", style: .default) { (_) in
        guard let text = alertController.textFields?.first?.text, text != "" else {
          return
        }
        // Update
        tagsView.update("#\(text)", at: tagButton.index)
      }
      appendAction.setValue(UIColor.black, forKey: "titleTextColor")
      alertController.addAction(appendAction)
      
      self.present(alertController, animated: true, completion: nil)
      
    }
    appendAction.setValue(UIColor.black, forKey: "titleTextColor")
    alertController.addAction(appendAction)
    
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (_) in
      // Remove
      tagsView.remove(tagButton)
    }
    deleteAction.setValue(UIColor.black, forKey: "titleTextColor")
    alertController.addAction(deleteAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
}

// MARK: - UploadPostInputAccessoryViewDelegate

extension UploadPostController: UploadPostInputAccessoryViewDelegate {
  
  func selectPhoto() {
    inputAccessoryView?.isHidden = true
    self.present(imagePicker, animated: true, completion: nil)
  }
  
  func selectMusic() {
    // search music controller init, 실행
    // vc.delegate = self 설정
  }
  
  func selectClose() {
    view.endEditing(true)
  }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension UploadPostController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    var newImage: UIImage?
    
    if let possibleImage = info[.editedImage] as? UIImage {
      newImage = possibleImage
    } else if let possibleImage = info[.originalImage] as? UIImage {
      newImage = possibleImage
    }
    
    imageView.image = newImage
    imageView.snp.updateConstraints { make in
      make.height.equalTo(300)
    }
    picker.dismiss(animated: true) {
      self.inputAccessoryView?.isHidden = false
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true) {
      self.inputAccessoryView?.isHidden = false
    }
  }
}
