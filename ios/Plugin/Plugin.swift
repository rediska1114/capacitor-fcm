import Capacitor
import Foundation

import FirebaseCore
import FirebaseInstallations
import FirebaseMessaging

@objc(CapacitorFCM)
public class CapacitorFCM: CAPPlugin, MessagingDelegate {
  override public func load() {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
    Messaging.messaging().delegate = self
    NotificationCenter.default.addObserver(self, selector: #selector(didRegisterWithToken(notification:)), name: Notification.Name(CAPNotifications.DidRegisterForRemoteNotificationsWithDeviceToken.name()), object: nil)
  }

  @objc func didRegisterWithToken(notification: NSNotification) {
    guard let deviceToken = notification.object as? Data else {
      return
    }
    Messaging.messaging().apnsToken = deviceToken
  }

  @objc func subscribeTo(_ call: CAPPluginCall) {
    guard let topicName = call.getString("topic") else {
      return call.reject("missing topic option")
    }
    Messaging.messaging().subscribe(toTopic: topicName) { error in
      if error != nil {
        print("ERROR while trying to subscribe topic \(topicName)")
        call.reject("Can't subscribe to topic \(topicName)")
      } else {
        call.resolve([
          "message": "subscribed to topic \(topicName)",
        ])
      }
    }
  }

  @objc func unsubscribeFrom(_ call: CAPPluginCall) {
    guard let topicName = call.getString("topic") else {
      return call.reject("missing topic option")
    }

    Messaging.messaging().unsubscribe(fromTopic: topicName) { error in
      if error != nil {
        call.reject("Can't unsubscribe from topic \(topicName)")
      } else {
        call.resolve([
          "message": "unsubscribed from topic \(topicName)",
        ])
      }
    }
  }

  @objc func getToken(_ call: CAPPluginCall) {
    Messaging.messaging().token { token, error in
      if let error = error {
        print("Error fetching FCM registration token: \(error)")
        call.reject("Failed to get instance FirebaseID", error.localizedDescription)
      } else if let token = token {
        print("FCM registration token: \(token)")
        call.resolve([
          "token": token,
        ])
      }
    }
  }

  @objc func deleteInstance(_ call: CAPPluginCall) {
    Installations.installations().delete { error in
      if let error = error {
        print("Error deleting installation: \(error)")
        call.reject("Cant delete Firebase Instance ID", error.localizedDescription)
      }
      call.resolve()
    }
  }

  @objc func setAutoInit(_ call: CAPPluginCall) {
    let enabled: Bool = call.getBool("enabled") ?? false
    Messaging.messaging().isAutoInitEnabled = enabled
    call.resolve()
  }

  @objc func isAutoInitEnabled(_ call: CAPPluginCall) {
    call.resolve([
      "enabled": Messaging.messaging().isAutoInitEnabled,
    ])
  }
}
