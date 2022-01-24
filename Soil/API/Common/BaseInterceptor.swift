//
//  BaseInterceptor.swift
//  Soil
//
//  Created by dykoon on 2022/01/18.
//

import Foundation

import Alamofire
import Firebase
import KeychainAccess

class BaseInterceptor: RequestInterceptor {

  private let keychain = Keychain(service: "com.chuncheonian.Soil")
  let retryLimit = 1
  let retryDelay: TimeInterval = 30
  
  func adapt(
    _ urlRequest: URLRequest,
    for session: Session,
    completion: @escaping (Result<URLRequest, Error>) -> Void
  ) {
    print("DEBUG: BaseInterceptor - adapt() called")
    
    var urlRequest = urlRequest
    
    if let token = try? keychain.get("token") {
      print("DEBUG: token - \(token)")
      urlRequest.headers.add(.authorization(token))
    }
    
    urlRequest.headers.add(.accept("application/json; charset=UTF-8"))
    
    completion(.success(urlRequest))
  }
  
  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    print("DEBUG: BaseInterceptor - retry() called")
    
    // statusCode가 안들어왔을때 다시 전송 X
    guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
      completion(.doNotRetryWithError(error))
      return
    }
    
    Auth.auth().currentUser?.getIDToken(completion: { idToken, error in
      if let error = error {
        print("DEBUG: Failed to fetch idToken with error \(error.localizedDescription)")
        return
      }
      
      guard let idToken = idToken else { return }
      // print("token - \(idToken)")
      
      do {
        try self.keychain.set(idToken, key: "token")
        
        if request.retryCount < self.retryLimit {
          completion(.retry)
        }
        
      } catch let error {
        fatalError("DEBUG: Failed to add keychain with error \(error.localizedDescription)")
      }
    })
  }
}
