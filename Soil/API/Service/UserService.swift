//
//  UserService.swift
//  Soil
//
//  Created by dykoon on 2021/11/09.
//

import UIKit
import Alamofire
import Firebase

struct UserService {
    
  static func fetchUser(
    request: FetchUserRequest,
    completion: @escaping (DataResponse<User, AFError>) -> Void
  ) {
    AFManager
      .shared
      .session
      .request(UserRouter.fetchUser(request))
      .validate(statusCode: 200..<401)
      .validate(contentType: ["application/json"])
      .responseDecodable(of: User.self, completionHandler: completion)
  }
  
  static func updateUser(
    request: UpdateUserRequest,
    completion: @escaping (AFDataResponse<Data?>) -> Void
  ) {
    let route = UserRouter.updateUser(request)
    
    AFManager
      .shared
      .session
      .upload(multipartFormData: route.multipartFormData, with: route)
      .validate(statusCode: 200..<401)
      .validate(contentType: ["application/json"])
      .response(completionHandler: completion)
  }
}
