//
//  PostRouter.swift
//  Soil
//
//  Created by Jinyoung Kim on 2022/02/27.
//

import Foundation
import Alamofire

enum PostRouter {
  case uploadPost(PostUploadRequest)
}

extension PostRouter: APIConfiguration {
  var method: HTTPMethod {
    return .post
  }
  
  var path: String {
    switch self {
    case .uploadPost:
      return "posts"
    }
  }
  
  var headerContentType: String {
    switch self {
    case .uploadPost:
      return "multipart/form-data"
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .uploadPost:
      return .none
    }
  }
  
  var multipartFormData: MultipartFormData? {
    switch self {
    case .uploadPost(let request):
      let multipartFormData = MultipartFormData()
      multipartFormData.append(Data(request.title.utf8), withName: "title")
      multipartFormData.append(Data(String(request.isSecret).utf8), withName: "isSecret")
      request.tags.forEach {
        multipartFormData.append(Data($0.utf8), withName: "tags")
      }
      multipartFormData.append(Data(request.content.utf8), withName: "content")
      if let imageData = request.imageData {
        multipartFormData.append(
          imageData,
          withName: "file",
          fileName: "\(imageData).jpeg",
          mimeType: "image/jpeg"
        )
      } else {
        multipartFormData.append(
          "".data(using: .utf8)!,
          withName: "file",
          fileName: "",
          mimeType: ""
        )
      }
      multipartFormData.append(Data(request.song.utf8), withName: "song")
      return multipartFormData
    }
  }
}
