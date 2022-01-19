//
//  MyLogger.swift
//  Soil
//
//  Created by dykoon on 2022/01/18.
//

import Foundation
import Alamofire

final class MyLogger: EventMonitor {
  
  let queue = DispatchQueue(label: "com.chuncheonian.Soil.networklogger")
  
  func requestDidResume(_ request: Request) {
    print("DEBUG: MyLogger - requestDidResume() called")
    debugPrint(request)
  }
  
  func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
    print("DEBUG: MyLogger - didParseResponse() called")
    debugPrint(response)
  }
  
}
