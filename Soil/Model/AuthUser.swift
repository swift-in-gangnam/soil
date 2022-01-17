//
//  AuthUser.swift
//  Soil
//
//  Created by 임영선 on 2022/01/02.
//

import Foundation
import UIKit
class AuthUser {
  static let shared = AuthUser()
  
  var email: String?
  var password: String?
  var nickname: String?
  var name: String?
  var profileImage: UIImage?
  
  private init() { }
  
  func initUser() {
    email = nil
    password = nil
    nickname = nil
    name = nil
    profileImage = nil
  }
  
}
