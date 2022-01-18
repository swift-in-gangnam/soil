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
}

extension UserRouter: TargetType {
  
  var baseURL: String {
    return "http://15.165.215.29:8080/user/"
  }

  var method: HTTPMethod {
    switch self {
    case .fetchUser:
      return .get
    case .updateUser:
      return .patch
    }
  }

  var path: String {
    switch self {
    case .fetchUser(let request):
      return request.uid
    case .updateUser:
      return ""
    }
  }
  
  var headerContentType: String {
    switch self {
    case .fetchUser:
      return "application/json; charset=UTF-8"
    case .updateUser:
      return "multipart/form-data"
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .fetchUser:
      return .none
    case .updateUser:
      return .none
    }
  }
  
  var multipartFormData: MultipartFormData {
    let multipartFormData = MultipartFormData()
    switch self {
    case .updateUser(let request):
      multipartFormData.append(request.name.data(using: .utf8)!, withName: "name")
      multipartFormData.append(request.bio.data(using: .utf8)!, withName: "bio")
      
      if let file = request.file {
        multipartFormData.append(file, withName: "file", fileName: "\(file).jpeg", mimeType: "image/jpeg")
      } else {
        multipartFormData.append("".data(using: .utf8)!, withName: "file", fileName: "", mimeType: "")
      }
    default: ()
    }

    return multipartFormData
  }
}
