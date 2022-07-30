//
//  AppDelegate.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/02.
//

import UIKit

import Firebase
import FirebaseAnalytics
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // setup firebase
    FirebaseApp.configure()
    FirebaseConfiguration.shared.setLoggerLevel(.min)
    
    // setup notification
    setFirebaseCloudMessaging(application)
    
    return true
  }
  
  // MARK: - UISceneSession Lifecycle
  
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
  
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
  
  /// 앱이 foreground 상태일 때의 notification 핸들링 delegate
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    return [.banner, .sound, .list, .badge]
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
  
  /// push notification 클릭 이벤트 핸들링 delegate
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
    print(#fileID, #function, response.notification.request.content.title)
    print(#fileID, #function, response.notification.request.content.body)
    return
  }
}

extension AppDelegate {
  private func setFirebaseCloudMessaging(_ applitcation: UIApplication) {
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self
    
    applitcation.registerForRemoteNotifications()
  }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("DEBUG: fcmToken - \(fcmToken ?? "")")
  }
}
