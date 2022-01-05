//
//  UserService.swift
//  Soil
//
//  Created by dykoon on 2021/11/09.
//

import UIKit
import Firebase
import KeychainAccess

struct UserService {
    
  static func fetchUser(completion: @escaping (User) -> Void) {
    guard let uid = Auth.auth().currentUser?.uid else { return }

    firestoreUsers.document(uid).getDocument { snapshot, _ in
      guard let dictionary = snapshot?.data() else { return }
      let user = User(dictionary: dictionary)
      completion(user)
    }
  }
  
  static func fetchUsers(completion: @escaping ([User]) -> Void) {
    firestoreUsers.getDocuments { snapshot, _ in
      guard let snapshot = snapshot else { return }
      let users = snapshot.documents.map({ User(dictionary: $0.data()) })
      completion(users)
    }
  }
  
  static func updateUser(
    user: User,
    data: [String: Any],
    profileImage: UIImage?,
    completion: @escaping (FirestoreCompletion)
  ) {
    if let profileImage = profileImage {
      StorageService.updateImage(uuid: user.profileImageUUID, image: profileImage) { imageURL in
        var mutatedData = data
        mutatedData["profileImageURL"] = imageURL
        firestoreUsers.document(user.uid).updateData(mutatedData, completion: completion)
      }
    } else {
      firestoreUsers.document(user.uid).updateData(data, completion: completion)
    }
  }
}
