//
//  User.swift
//  Soil
//
//  Created by dykoon on 2021/11/09.
//

import Foundation
import Firebase

struct User: Codable, Hashable {
  let uid: String
  let name: String?
  let nickname: String
  let bio: String?
  let profileImageURL: String?
  let followers: Int
  let following: Int
  
//  var isCurrentUser: Bool {
//    return Auth.auth().currentUser?.uid == self.uid
//  }
  
  enum CodingKeys: String, CodingKey {
    case uid, name, nickname, bio
    case profileImageURL = "imageUrl"
    case followers = "followerCnt"
    case following = "followingCnt"
  }
}
