//
//  AuthService.swift
//  Soil
//
//  Created by dykoon on 2021/11/09.
//

import UIKit
import Firebase

struct AuthCredentials {
  let email: String
  let password: String
  let fullname: String
  let username: String
  let profileImage: UIImage
}

struct AuthService {
    
  static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
    Auth.auth().signIn(withEmail: email, password: password, completion: completion)
  }
    
  static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping (Error?) -> Void) {
    StorageService.uploadImage(image: credentials.profileImage) { imageUUID, imageURL in
      Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
        if let error = error {
          print("DEBUG: Failed to register user \(error.localizedDescription)")
          return
        }

        guard let uid = result?.user.uid else { return }

        let data: [String: Any] = [
          "uid": uid,
          "email": credentials.email,
          "fullname": credentials.fullname,
          "username": credentials.username,
          "profileImageURL": imageURL,
          "profileImageUUID": imageUUID
        ]
        firestoreUsers.document(uid).setData(data, completion: completion)
      }
    }
  }
}
