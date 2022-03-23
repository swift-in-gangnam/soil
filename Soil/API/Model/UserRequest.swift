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
}

struct PostUserRequest: Encodable {
  let email: String
  let nickname: String
  let name: String
  let file: Data?
}
