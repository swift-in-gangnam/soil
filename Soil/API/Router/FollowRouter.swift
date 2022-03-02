//
//  FollowRouter.swift
//  Soil
//
//  Created by dykoon on 2022/02/20.
//

import Foundation
import Alamofire

enum FollowRouter {
  case followUser(FollowUserRequest)
  case unfollowUser(UnfollowUserRequest)
  
}

extension FollowRouter: APIConfiguration {
  
  var method: HTTPMethod {
    switch self {
    case .followUser:
      return .post
    case .unfollowUser:
      return .delete
    }
  }

  var path: String {
    switch self {
    case .followUser(let request):
      return "follow/\(request.followingUID)"
    case .unfollowUser(let request):
      return "follow/\(request.unfollowUID)"
    }
  }
  
  var headerContentType: String {
    switch self {
    case .followUser:
      return "application/json; charset=UTF-8"
    case .unfollowUser:
      return "application/json; charset=UTF-8"
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .followUser:
      return .none
    case .unfollowUser:
      return .none
    }
  }
}
