//
//  UserService.swift
//  Soil
//
//  Created by dykoon on 2021/11/09.
//

import UIKit
import Firebase

struct UserService {
    
  static func fetchUser(completion: @escaping(User) -> Void) {
    guard let uid = Auth.auth().currentUser?.uid else { return }

    COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
      guard let dictionary = snapshot?.data() else { return }
      let user = User(dictionary: dictionary)
      completion(user)
    }
  }
    
  static func fetchUsers(completion: @escaping([User]) -> Void) {
    COLLECTION_USERS.getDocuments { snapshot, _ in
      guard let snapshot = snapshot else { return }
      let users = snapshot.documents.map({ User(dictionary: $0.data()) })
      completion(users)
    }
  }
  
  static func updateUser(
    user: User,
    data: [String: Any],
    profileImage: UIImage?,
    completion: @escaping(FirestoreCompletion)
  ) {
    if let profileImage = profileImage {
      StorageService.updateImage(uuid: user.profileImageUUID, image: profileImage) { imageURL in
        var mutatedData = data
        mutatedData["profileImageURL"] = imageURL
        COLLECTION_USERS.document(user.uid).updateData(mutatedData, completion: completion)
      }
    } else {
      COLLECTION_USERS.document(user.uid).updateData(data, completion: completion)
    }
  }
}
