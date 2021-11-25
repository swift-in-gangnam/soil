//
//  StorageService.swift
//  Soil
//
//  Created by dykoon on 2021/11/09.
//

import UIKit
import FirebaseStorage

struct StorageService {
    
  static func uploadImage(image: UIImage, completion: @escaping(String, String) -> Void) {
        
    // UIImage -> Data
    guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
    let filename = NSUUID().uuidString
    let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
    ref.putData(imageData, metadata: nil) { _, error in
      if let error = error {
        print("DEBUG: Failed to upload image \(error.localizedDescription)")
        return
      }
            
      ref.downloadURL { url, _ in
        guard let imageURL = url?.absoluteString else { return }
        completion(filename, imageURL)
      }
    }
  }
  
  static func updateImage(uuid: String, image: UIImage, completion: @escaping(String) -> Void) {
    guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
    let ref = Storage.storage().reference(withPath: "/profile_images/\(uuid)")
        
    ref.putData(imageData, metadata: nil) { _, error in
      if let error = error {
        print("DEBUG: Failed to update image \(error.localizedDescription)")
        return
      }
            
      ref.downloadURL { url, _ in
        guard let imageURL = url?.absoluteString else { return }
        completion(imageURL)
      }
    }
  }
}
