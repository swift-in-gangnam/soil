//
//  CompletedController.swift
//  Soil
//
//  Created by 임영선 on 2021/11/17.
//

import UIKit
import Lottie
import Firebase
import Alamofire
import KeychainAccess

class SignUpCompletedController: UIViewController {
  // MARK: - Properties
  let animationView = AnimationView()
  private let keychain = Keychain(service: "com.swift-in-gangnam.Soil")

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    setUpAnimation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
    animationView.play()
  }
  
  // MARK: - Methods
  @IBAction func didTabStart(_ sender: UIButton) {
    registerUser()
  }
  
  func setUpAnimation() {
    animationView.animation = Animation.named("70170-success-check")
    let x = self.view.center.x - 150
    let y = self.view.center.y - 170
    animationView.frame = CGRect(x: x, y: y, width: 300, height: 300)
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    animationView.animationSpeed = 0.5
    view.addSubview(animationView)
  }
  
  func registerUser() {
    let user = AuthUser.shared
    guard let email = user.email else { return }
    guard let password = user.password else { return }
    
    // firebase Auth에 user 생성
    Auth.auth().createUser(withEmail: email, password: password) { result, error  in
      if let error = error {
        print("DEBUG: Failed to register firebase user with error \(error.localizedDescription)")
      }
      
      guard let result = result else { return }
      
      // idToken, uid를 Keychain에 저장
      result.user.getIDToken(completion: { idToken, error in
        if let error = error {
          print("DEBUG: Failed to fetch idToken with error \(error.localizedDescription)")
          return
        }
        
        guard let idToken = idToken else { return }
     
        do {
          try self.keychain.set(idToken, key: "token")
          try self.keychain.set(result.user.uid, key: "uid")
        } catch let error {
          fatalError("DEBUG: Failed to add keychain with error \(error.localizedDescription)")
        }
        
        // API
        let url = "http://15.165.215.29:8080/user"
       
        let headers: HTTPHeaders = [
          .authorization(idToken),
          .accept("multipart/form-data")
        ]
       
        guard let email = AuthUser.shared.email else { return }
        guard let nickname = AuthUser.shared.nickname else { return }
        guard let username = AuthUser.shared.name else { return }
        
        let parameters: [String: Any] = [
          "email": email,
          "nickname": nickname,
          "name": username
        ]
     
        AF.upload(
          multipartFormData: { multipartFormData in
            for (key, value) in parameters {
              multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            if let imageData = AuthUser.shared.profileImage?.jpegData(compressionQuality: 0.75) {
              multipartFormData.append(imageData, withName: "file",
                                       fileName: "\(imageData).jpeg", mimeType: "image/jpeg")
            } else {
              multipartFormData.append("".data(using: .utf8)!, withName: "file", fileName: "", mimeType: "")
            }
          },
          to: url,
          method: .post,
          headers: headers).responseJSON { response in
            // debugPrint(response)
            switch response.result {
            case .success(let value):
              print("signUp - \(value)")
             
            case .failure(let error):
              print("DEBUG: Failed to signUp with error \(error.localizedDescription)")
            }
          }
      })
      AuthUser.shared.initUser()
    }
  }
}
