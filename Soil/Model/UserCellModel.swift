//
//  UserCellModel.swift
//  Soil
//
//  Created by dykoon on 2022/01/26.
//

import Foundation

struct UserCellModel: Codable, Hashable {
  
  let uid: String
  let name: String?
  let nickname: String
  let profileImageURL: String?
  
  enum CodingKeys: String, CodingKey {
    case uid = "user_uid"
    case name, nickname
    case profileImageURL = "imageUrl"
  }
}
