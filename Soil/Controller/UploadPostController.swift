//
//  UploadPostController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/03.
//

import UIKit
import SnapKit
import Then
import Tags

class UploadPostController: UIViewController {
  
  // MARK: - Properties
  
  private lazy var imagePicker = UIImagePickerController().then {
    $0.sourceType = .photoLibrary
    $0.allowsEditing = true
    $0.delegate = self
  }
  
  private let titleButtonAttributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.font: UIFont.montserrat(size: 16, family: .medium),
    NSAttributedString.Key.foregroundColor: UIColor.black
  ]
  
  private lazy var cancelButton = UIBarButtonItem().then {
    $0.title = "Cancel"
    $0.setTitleTextAttributes(titleButtonAttributes, for: .normal)
    $0.target = self
    $0.action = #selector(didTapCancel)
  }
  
  private lazy var doneButton = UIBarButtonItem().then {
    $0.title = "Write"
    $0.setTitleTextAttributes(titleButtonAttributes, for: .normal)
    $0.target = self
    $0.action = #selector(didTapDone)
  }
  
  private let scrollView = UIScrollView().then {
    $0.keyboardDismissMode = .interactive
  }
  
  private let titleTextField = UITextField().then {
    $0.placeholder = "제목"
    var attributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.font: UIFont.notoSansKR(size: 25, family: .regular),
      NSAttributedString.Key.foregroundColor: UIColor.systemGray3
    ]
    $0.attributedPlaceholder = NSAttributedString(
      string: "제목",
      attributes: attributes
    )
    attributes[NSAttributedString.Key.foregroundColor] = UIColor.black
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
  
  private let isSecretButton = UIButton(type: .system).then {
    $0.setImage(UIImage(systemName: "square"), for: .normal)
    $0.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
    $0.setImage(UIImage(systemName: "checkmark.square"), for: .highlighted)
    $0.setTitle("비밀일기로 쓰기", for: .normal)
    $0.tintColor = UIColor.darkGray
  }
  
  private let tagsView = TagsView()
  
  private let textView = UITextView().then {
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
    configureTextView()
    configureImageView()
  }
  
  override var inputAccessoryView: UIView? {
    return customInputAccessoryView
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  // MARK: - Helpers
  
  private func configureUI() {
    
    // MARK: - Configure Navigation Bar
    
    let naviBar = UINavigationBar(frame: CGRect(
      x: 0,
      y: 0,
      width: view.frame.width, height: 44)
    )
    naviBar.isTranslucent = false
    naviBar.backgroundColor = UIColor.soilBackgroundColor
    
    let naviItem = UINavigationItem(title: "")
    naviItem.leftBarButtonItem = cancelButton
    naviItem.rightBarButtonItem = doneButton
    
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
    
    contentsView.addSubview(textView)
    textView.snp.makeConstraints { make in
      make.top.equalTo(seperator3.snp.bottom).offset(40)
      make.leading.trailing.equalToSuperview().inset(30)
      make.height.greaterThanOrEqualTo(200)
      make.bottom.lessThanOrEqualToSuperview() // imageView의 height가 0일 경우 대비
    }
    
    contentsView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.top.equalTo(textView.snp.bottom).offset(100)
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
  
  private func configureTextView() {
    textView.delegate = self
    let text = "나만의 소중한 일상을 기록해보세요"
    let attributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.font: UIFont.notoSansKR(size: 15, family: .regular),
      NSAttributedString.Key.foregroundColor: UIColor.lightGray
    ]
    textView.attributedText = NSAttributedString(string: text, attributes: attributes)
  }
  
  private func configureImageView() {
    let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
    imageView.addGestureRecognizer(tapGR)
    imageView.isUserInteractionEnabled = true
  }
  
  // MARK: - Actions
  
  @objc private func didTapCancel() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc private func didTapDone() {
    print("DEBUG: done Tapped...")
  }
  
  @objc private func didTapImageView(gestureRecognizer: UITapGestureRecognizer) {
    let alertController = UIAlertController(title: nil, message: "이미지를 삭제하시겠어요?", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (_) in
      self.imageView.snp.updateConstraints { make in
        make.height.equalTo(0)
      }
      self.imageView.image = nil
    }
    deleteAction.setValue(UIColor.black, forKey: "titleTextColor")
    alertController.addAction(cancelAction)
    alertController.addAction(deleteAction)
    self.present(alertController, animated: true, completion: nil)
  }
}

// MARK: - UITextViewDelegate

extension UploadPostController: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont.notoSansKR(size: 15, family: .regular),
        NSAttributedString.Key.foregroundColor: UIColor.black
      ]
      textView.typingAttributes = attributes
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      let text = "나만의 소중한 일상을 기록해보세요"
      let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont.notoSansKR(size: 15, family: .regular),
        NSAttributedString.Key.foregroundColor: UIColor.lightGray
      ]
      textView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
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
    
    if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      newImage = possibleImage
    } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
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
}
