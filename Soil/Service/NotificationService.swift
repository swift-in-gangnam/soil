//
//  NotificationService.swift
//  Soil
//
//  Created by dykoon on 2022/06/02.
//

import Foundation
import UserNotifications

final class NotificationService: NSObject {
  
  override init() {
    super.init()
  }
  
  func requestNotificationAuthorization() {

    let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
    
    UNUserNotificationCenter.current().requestAuthorization(options: authOption) { _, error in
      if let error = error {
        print(error.localizedDescription)
      } else {
        print("DEBUG: Notifications are granted")
      }
    }
  }
}
