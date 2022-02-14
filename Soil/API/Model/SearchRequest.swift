//
//  SearchRequest.swift
//  Soil
//
//  Created by dykoon on 2022/01/25.
//

import Foundation

struct SearchRequest: Encodable {
  let query: String
  let type: String
}
