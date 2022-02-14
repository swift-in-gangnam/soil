//
//  UserCellViewModel.swift
//  Soil
//
//  Created by dykoon on 2022/01/25.
//

import Foundation

struct UserCellViewModel {
  
  private let userCell: UserCellModel
  
  var profileImageURL: URL? {
    return URL(string: userCell.profileImageURL ?? "")
  }
  
  var nickname: String {
    return userCell.nickname
  }
  
  var name: String {
    return userCell.name ?? ""
  }
  
  init(userCell: UserCellModel) {
    self.userCell = userCell
  }
}
