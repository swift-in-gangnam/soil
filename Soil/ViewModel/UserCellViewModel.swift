//
//  UserCellViewModel.swift
//  Soil
//
//  Created by dykoon on 2022/01/25.
//

import Foundation

struct UserCellViewModel {
  
  private let user: User
  
  var profileImageURL: URL? {
    return URL(string: user.profileImageURL ?? "")
  }
  
  var nickname: String {
    return user.nickname
  }
  
  var name: String {
    return user.name ?? ""
  }
  
  init(user: User) {
    self.user = user
  }
}
