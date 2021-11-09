//
//  User.swift
//  Soil
//
//  Created by dykoon on 2021/11/09.
//

import Foundation
import Firebase

struct User {
  
  let uid: String
  let email: String
  let fullname: String
  let username: String
  let profileImageURL: String
  let profileImageUUID: String
  
  var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == self.uid }
    
  init(dictionary: [String: Any]) {
    self.uid = dictionary["uid"] as? String ?? ""
    self.email = dictionary["email"] as? String ?? ""
    self.fullname = dictionary["fullname"] as? String ?? ""
    self.username = dictionary["username"] as? String ?? ""
    self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    self.profileImageUUID = dictionary["profileImageUUID"] as? String ?? ""
  }
}
