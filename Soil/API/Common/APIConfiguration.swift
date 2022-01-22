//
//  TargetType.swift
//  Soil
//
//  Created by dykoon on 2022/01/18.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
  var method: HTTPMethod { get }
  var path: String { get }
  var headerContentType: String { get }
  var parameters: RequestParams { get }
}

extension APIConfiguration {

  // URLRequestConvertible 구현
  func asURLRequest() throws -> URLRequest {
    let url = try "http://15.165.215.29:8080".asURL()
    var request = URLRequest(url: url.appendingPathComponent(path))
    request.method = method
    request.headers.add(.contentType(headerContentType))
        
    switch parameters {
    case .body(let params):
      request = try JSONParameterEncoder().encode(params?.toDictionary(), into: request)
    case .query(let params):
      request = try URLEncodedFormParameterEncoder().encode(params?.toDictionary(), into: request)
    default:
      break
    }
    
    return request
  }
}

enum RequestParams {
  case query(Encodable?)
  case body(Encodable?)
  case none
}

extension Encodable {
  func toDictionary() -> [String: String] {
    guard let data = try? JSONEncoder().encode(self),
          let jsonData = try? JSONSerialization.jsonObject(with: data),
          let dictionaryData = jsonData as? [String: String] else { return [:] }
    return dictionaryData
  }
}
