//
//  UserRouter.swift
//  Soil
//
//  Created by dykoon on 2022/01/18.
//

import Foundation
import Alamofire

enum UserRouter {
  case fetchUser(FetchUserRequest)
  case updateUser(UpdateUserRequest)
  case postUser(PostUserRequest)
  case fetchFollowingsList(UserStatsRequest)
  case fetchFollowerList(UserStatsRequest)
}

extension UserRouter: APIConfiguration {
  
  var method: HTTPMethod {
    switch self {
    case .fetchUser:
      return .get
    case .updateUser:
      return .patch
    case .postUser:
      return .post
    case .fetchFollowingsList:
      return .get
    case .fetchFollowerList:
      return .get
    }
  }

  var path: String {
    switch self {
    case .fetchUser(let request):
      return "users/\(request.uid)"
    case .updateUser:
      return "users"
    case .postUser:
      return "users"
    case .fetchFollowingsList(let request):
      return "users/\(request.uid)/following"
    case .fetchFollowerList(let request):
      return "users/\(request.uid)/follower"
    }
  }
  
  var headerContentType: String {
    switch self {
    case .fetchUser:
      return "application/json; charset=UTF-8"
    case .updateUser:
      return "multipart/form-data"
    case .postUser:
      return "multipart/form-data"
    case .fetchFollowingsList:
      return "application/json; charset=UTF-8"
    case .fetchFollowerList:
      return "application/json; charset=UTF-8"
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .fetchUser:
      return .none
    case .updateUser:
      return .none
    case .postUser:
      return .none
    case .fetchFollowingsList:
      return .none
    case .fetchFollowerList:
      return .none
    }
  }
  
  var multipartFormData: MultipartFormData {
    let multipartFormData = MultipartFormData()
    
    switch self {
    case .updateUser(let request):
      multipartFormData.append(request.name.data(using: .utf8)!, withName: "name")
      multipartFormData.append(request.bio.data(using: .utf8)!, withName: "bio")
      multipartFormData.append(request.isDelete.description.data(using: .utf8)!, withName: "isDelete")
      
      if let file = request.file {
        multipartFormData.append(file, withName: "file", fileName: "\(file).jpeg", mimeType: "image/jpeg")
      } else {
        multipartFormData.append("".data(using: .utf8)!, withName: "file", fileName: "", mimeType: "")
      }
    case .postUser(let request):
      multipartFormData.append(request.email.data(using: .utf8)!, withName: "email")
      multipartFormData.append(request.nickname.data(using: .utf8)!, withName: "nickname")
      multipartFormData.append(request.name.data(using: .utf8)!, withName: "name")
      multipartFormData.append(request.fcmToken.data(using: .utf8)!, withName: "fcmToken")
      
      if let file = request.file {
        multipartFormData.append(file, withName: "file", fileName: "\(file).jpeg", mimeType: "image/jpeg")
      } else {
        multipartFormData.append("".data(using: .utf8)!, withName: "file", fileName: "", mimeType: "")
      }
    default:
      break
    }

    return multipartFormData
  }
}
