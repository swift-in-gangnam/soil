//
//  SearchService.swift
//  Soil
//
//  Created by dykoon on 2022/01/26.
//

import Foundation
import Alamofire

struct SearchService {
  
  static func search(
    request: SearchRequest,
    completion: @escaping (DataResponse<GeneralResponse<[UserCellModel]>, AFError>) -> Void
  ) {
    AFManager
      .shared
      .session
      .request(SearchRouter.search(request))
      .validate(statusCode: 200..<401)
      .validate(contentType: ["application/json"])
      .responseDecodable(of: GeneralResponse<[UserCellModel]>.self, completionHandler: completion)
  }
}
