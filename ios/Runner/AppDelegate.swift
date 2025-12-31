import UIKit
import Flutter
import StoreKit
import GoogleMaps
import Firebase
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Initialize Firebase
    FirebaseApp.configure()

    // FCM Foreground Notifications
    UNUserNotificationCenter.current().delegate = self

    // Register for APNs
    application.registerForRemoteNotifications()

    //Get FlutterViewController
    guard let controller = window?.rootViewController as? FlutterViewController else {
        fatalError("rootViewController is not type FlutterViewController")
    }

    // Method channel for receipt
    let receiptChannel = FlutterMethodChannel(name:"com.avioflai.aviation/receipt",binaryMessenger:controller.binaryMessenger)

    receiptChannel.setMethodCallHandler { call, result in
        if call.method == "getReceiptData" {
            guard let receiptURL = Bundle.main.appStoreReceiptURL,
                  let receiptData = try? Data(contentsOf: receiptURL) else {
                result(FlutterError(code: "NO_RECEIPT", message: "Receipt not found", details: nil))
                return
            }
            let base64Receipt = receiptData.base64EncodedString()
            result(base64Receipt)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
      let channel = FlutterMethodChannel(name: "com.app/google_maps",binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { call, result in
          if call.method == "googleMapsKey" {
              if let args = call.arguments as? [String: Any],
                  let key = args["key"] as? String{
                  //Google Maps API
                  GMSServices.provideAPIKey(key)
                  print("Google Maps key initialized: \(key)")
                  result(true)
              } else {
                  result(FlutterError(code: "INVALID_KEY",message: "Key missing",details: nil))
              }
          } else {
              result(FlutterMethodNotImplemented)
          }
      }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  //  MOST IMPORTANT PART — REQUIRED FOR PUSH NOTIFICATIONS
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
      print("APNs token received")
      Messaging.messaging().apnsToken = deviceToken
      super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}
