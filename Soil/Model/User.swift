//
//  User.swift
//  Soil
//
//  Created by dykoon on 2021/11/09.
//

import Foundation

struct User: Codable {
  
  let name: String?
  let nickname: String
  let bio: String?
  let profileImageURL: String?
  let followers: Int
  let following: Int
  
  enum CodingKeys: String, CodingKey {
    case name, nickname, bio
    case profileImageURL = "imageUrl"
    case followers = "followerCnt"
    case following = "followingCnt"
  }
}
