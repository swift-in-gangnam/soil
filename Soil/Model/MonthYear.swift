//
//  MonthYear.swift
//  Soil
//
//  Created by dykoon on 2022/05/02.
//

import UIKit

struct MonthYear: Codable, Hashable {
  private(set) var identifier = UUID()
  let date: [Date]
  
  func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
  }
}
