//
//  ProfileViewController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/12.
//
import UIKit

class ProfileInputController: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var profileButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var skipBarButton: UIBarButtonItem!
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    // barButton 폰트 적용
    let regularBarButtonTextAttributes: [NSAttributedString.Key: Any] =
    [.font: UIFont.notoSansKR(size: 18, family: .black)]
    skipBarButton.setTitleTextAttributes(regularBarButtonTextAttributes, for: .normal)
    
    nextButton.isEnabled = false
    nextButton.backgroundColor = .lightGray
  }
  
  // MARK: Actions
  @IBAction func selectProfilePhoto(_ sender: Any) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
  }
  
  @IBAction func didTabSkipButton(_ sender: UIBarButtonItem) {
    AuthUser.shared.profileImage = nil
  }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileInputController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    guard let selectedImage = info[.editedImage] as? UIImage else { return }
    profileButton.clipsToBounds = true
    profileButton.layer.cornerRadius = profileButton.frame.width / 2
    profileButton.setBackgroundImage(selectedImage, for: .normal)
    
    nextButton.isEnabled = true
    nextButton.backgroundColor = .black
    
    self.dismiss(animated: true, completion: nil)
    
    // authUser profileImage
    let authUser = AuthUser.shared
    authUser.profileImage = selectedImage
  
  }
}
