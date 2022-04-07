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
    }
  }

  var path: String {
    switch self {
    case .fetchUser(let request):
      return "user/\(request.uid)"
    case .updateUser:
      return "user"
    case .postUser:
      return "user"
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
