import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "com.example.app",
                                                  binaryMessenger: controller.binaryMessenger)
        batteryChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
          case "getBatteryLevel":
            UIDevice.current.isBatteryMonitoringEnabled = true
            if UIDevice.current.batteryState == .unknown {
              result(FlutterError(code: "UNAVAILABLE", message: "Battery info unavailable", details: nil))
            } else {
              result(Int(UIDevice.current.batteryLevel * 100))
            }
          default:
            result(FlutterMethodNotImplemented)
          }
        })

}
