//
//  UserCellModel.swift
//  Soil
//
//  Created by dykoon on 2022/01/26.
//

import Foundation

struct UserCellModel: Codable, Hashable {
  let uuid = UUID()
  let uid: String
  let name: String?
  let nickname: String
  let profileImageUrl: String?
  
  enum CodingKeys: String, CodingKey {
    case uid, name, nickname, profileImageUrl
  }
}
