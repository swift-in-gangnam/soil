//
//  SearchRouter.swift
//  Soil
//
//  Created by dykoon on 2022/01/25.
//

import Foundation
import Alamofire

enum SearchRouter {
  case search(SearchRequest)
}

extension SearchRouter: APIConfiguration {
  
  var method: HTTPMethod {
    return .get
  }
  
  var path: String {
    return "search"
  }
  
  var headerContentType: String {
    return ""
  }
  
  var parameters: RequestParams {
    switch self {
    case .search(let request):
      return .query(request)
    }
  }
}
