//
//  AuthRouter.swift
//  Soil
//
//  Created by 임영선 on 2022/02/20.
//

import Foundation
import Alamofire

enum AuthRouter {
  case login(LoginRequest)
  case logout
  case dupEmail(String)
  case dupNickName(String)
  
}

extension AuthRouter: APIConfiguration {
  var method: HTTPMethod {
    switch self {
    case .login:
      return .post
    case .logout:
      return .post
    case .dupEmail:
      return .get
    case .dupNickName:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .login:
      return "auth/login"
    case .logout:
      return "auth/logout"
    case .dupEmail(let email):
      return "auth/dupEmail/\(email)"
    case .dupNickName(let nickname):
      return "auth/dupNickname/\(nickname)"
    }
  }
  
  var headerContentType: String {
    switch self {
    case .login:
      return "application/json; charset=UTF-8"
    case .logout:
      return "application/json; charset=UTF-8"
    case .dupEmail:
      return "application/json; charset=UTF-8"
    case .dupNickName:
      return "application/json; charset=UTF-8"
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .login(let request):
      return .body(request)
    case .logout:
      return .none
    case .dupEmail:
      return .none
    case .dupNickName:
      return .none
    }
  }
}
