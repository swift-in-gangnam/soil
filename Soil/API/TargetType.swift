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
        
    switch parameters {
    case .body(let params):
      let params = params?.toDictionary() ?? [:]
      request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
      
    default: ()
    }
    
    return request
  }
}

enum RequestParams {
  case query(_: Encodable?)
  case body(_: Encodable?)
  case none
}

extension Encodable {
  func toDictionary() -> [String: Any] {
    guard let data = try? JSONEncoder().encode(self),
          let jsonData = try? JSONSerialization.jsonObject(with: data),
          let dictionaryData = jsonData as? [String: Any] else { return [:] }
    return dictionaryData
  }
}
