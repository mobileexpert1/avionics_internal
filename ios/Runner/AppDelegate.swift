import Flutter
import UIKit
import StoreKit  // 👈 Needed for receipt access

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Get FlutterViewController
    guard let controller = window?.rootViewController as? FlutterViewController else {
      fatalError("rootViewController is not type FlutterViewController")
    }

    // Define method channel
    let receiptChannel = FlutterMethodChannel(
      name: "com.avioflai.aviation/receipt",
      binaryMessenger: controller.binaryMessenger
    )

    // Handle method calls from Flutte r
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

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
