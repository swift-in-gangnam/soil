//
//  UserRequest.swift
//  Soil
//
//  Created by dykoon on 2022/01/19.
//

import Foundation

struct LoginRequest: Encodable {
  let fcmToken: String
}

struct FetchUserRequest: Encodable {
  let uid: String
}

struct UpdateUserRequest: Encodable {
  let name: String
  let bio: String
  let file: Data?
}
