//
//  User.swift
//  Soil
//
//  Created by dykoon on 2021/11/09.
//

import Foundation

struct User: Codable, Hashable {
  let uid: String
  let name: String?
  let nickname: String
  let bio: String?
  let profileImageURL: String?
  let followers: Int
  let following: Int
  let type: Int
    
  enum CodingKeys: String, CodingKey {
    case uid, name, nickname, bio, type
    case profileImageURL = "profileImageUrl"
    case followers = "followerCnt"
    case following = "followingCnt"
  }
}
