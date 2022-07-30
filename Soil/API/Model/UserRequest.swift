//
//  UserRequest.swift
//  Soil
//
//  Created by dykoon on 2022/01/19.
//

import Foundation

struct FetchUserRequest: Encodable {
  let uid: String
}

struct UpdateUserRequest: Encodable {
  let name: String
  let bio: String
  let file: Data?
  let isDelete: Bool  // 기존에 사진이 있으면서 삭제하는 경우 true
}

struct PostUserRequest: Encodable {
  let email: String
  let nickname: String
  let name: String
  let file: Data?
  let fcmToken: String
}

struct UserStatsRequest: Encodable {
  let uid: String
}
