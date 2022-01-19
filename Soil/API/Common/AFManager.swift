//
//  AFManager.swift
//  Soil
//
//  Created by dykoon on 2022/01/18.
//

import Foundation
import Alamofire

final class AFManager {
  
  static let shared = AFManager()
  
  let interceptors = Interceptor(interceptors: [BaseInterceptor()])
  
  let monitors = [MyLogger()]
  
  var session: Session
  
  private init() {
    session = Session(
      interceptor: interceptors
    )
  }
}
