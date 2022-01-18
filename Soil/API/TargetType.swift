//
//  TargetType.swift
//  Soil
//
//  Created by dykoon on 2022/01/18.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
  var baseURL: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var headerContentType: String { get }
  var parameters: RequestParams { get }
}

extension TargetType {

  // URLRequestConvertible 구현
  func asURLRequest() throws -> URLRequest {
    let url = try baseURL.asURL()
    var request = URLRequest(url: url.appendingPathComponent(path))
    request.method = method
    
    request.headers.add(.contentType(headerContentType))
    
//    switch parameters {
//    case .query(let request):
//      let params = request?.toDictionary() ?? [:]
//      let queryParams = params.map {
//        URLQueryItem(name: $0.key, value: "\($0.value)")
//      }
//      var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
//      components?.queryItems = queryParams
//      request.url = components?.url
//    case .body(let request):
//      let params = request?.toDictionary() ?? [:]
//      request.httpBody = try JSONSerialization.data(
//        withJSONObject: params, options: []
//      )
//    }
    return request
  }
}

enum RequestParams {
  case query(_ parameter: Encodable?)
  case body(_ parameter: Encodable?)
  case none
}
