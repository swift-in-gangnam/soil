//
//  FollowRequest.swift
//  Soil
//
//  Created by dykoon on 2022/02/20.
//

import Foundation

struct FollowUserRequest: Encodable {
  let followingUID: String
}

struct UnfollowUserRequest: Encodable {
  let unfollowUID: String
}
