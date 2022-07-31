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
    let notificationCenter = UNUserNotificationCenter.current()
    let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
    
    Task {
      do {
        try await notificationCenter.requestAuthorization(options: authOption)
        print("DEBUG: Notifications are granted")
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
