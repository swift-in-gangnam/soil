//
//  AuthService.swift
//  Soil
//
//  Created by dykoon on 2021/11/09.
//

import UIKit
import Alamofire
import Firebase

struct AuthService {
  static func firebaseLogin(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
    Auth.auth().signIn(withEmail: email, password: password, completion: completion)
  }

  static func login(
    request: LoginRequest,
    completion: @escaping (AFDataResponse<Data?>) -> Void
  ) {
    AFManager
      .shared
      .session
      .request(AuthRouter.login(request))
      .validate(statusCode: 200..<401)
      .validate(contentType: ["application/json"])
      .response(completionHandler: completion)
  }
  
  static func logout(
    completion: @escaping (DataResponse<Any, AFError>) -> Void
  ) {
  AFManager
      .shared
      .session
      .request(AuthRouter.logout)
      .validate(statusCode: 200..<401)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: completion)
    }
  
  static func getDupEmail(
    email: String,
    completion: @escaping (DataResponse<Any, AFError>) -> Void
  ) {
  AFManager
      .shared
      .session
      .request(AuthRouter.dupEmail(email))
      .validate(statusCode: 200..<401)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: completion)
    }
  
  static func getDupNickname(
    nickname: String,
    completion: @escaping (DataResponse<Any, AFError>) -> Void
  ) {
  AFManager
      .shared
      .session
      .request(AuthRouter.dupNickName(nickname))
      .validate(statusCode: 200..<401)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: completion)
    }
}
