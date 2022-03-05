//
//  FollowService.swift
//  Soil
//
//  Created by dykoon on 2022/02/20.
//

import UIKit
import Alamofire

struct FollowService {
  
  static func followUser(
    request: FollowUserRequest,
    completion: @escaping (DataResponse<GeneralResponse<User>, AFError>) -> Void
  ) {
    AFManager
      .shared
      .session
      .request(FollowRouter.followUser(request))
      .validate(statusCode: 200..<401)
      .validate(contentType: ["application/json"])
      .responseDecodable(of: GeneralResponse<User>.self, completionHandler: completion)
  }
  
  static func unfollowUser(
    request: UnfollowUserRequest,
    completion: @escaping (DataResponse<GeneralResponse<User>, AFError>) -> Void
  ) {
    AFManager
      .shared
      .session
      .request(FollowRouter.unfollowUser(request))
      .validate(statusCode: 200..<401)
      .validate(contentType: ["application/json"])
      .responseDecodable(of: GeneralResponse<User>.self, completionHandler: completion)
  }
}
