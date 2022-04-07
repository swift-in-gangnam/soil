//
//  PostService.swift
//  Soil
//
//  Created by Jinyoung Kim on 2022/02/27.
//

import Foundation
import Alamofire

struct PostService {
  
  static func uploadPost(
    data: PostUploadRequest,
    completionHandler: @escaping (AFDataResponse<Data?>) -> Void
  ) {
    let route = PostRouter.uploadPost(data)
    guard let multipartFormData = route.multipartFormData else { return }
    
    AFManager
      .shared
      .session
      .upload(multipartFormData: multipartFormData, with: route)
      .response(completionHandler: completionHandler)
  }
}
