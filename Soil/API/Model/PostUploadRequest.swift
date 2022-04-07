//
//  PostUploadRequest.swift
//  Soil
//
//  Created by Jinyoung Kim on 2022/02/27.
//

import Foundation

struct PostUploadRequest {
  
  let title: String
  let isSecret: Bool
  let tags: [String]
  let content: String
  let imageData: Data?
  let song: String
}
