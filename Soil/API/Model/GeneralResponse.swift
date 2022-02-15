//
//  GeneralResponse.swift
//  Soil
//
//  Created by dykoon on 2022/02/15.
//

import Foundation

struct GeneralResponse<T: Codable>: Codable {
  let success: Bool
  let message: String
  let data: T?
}
