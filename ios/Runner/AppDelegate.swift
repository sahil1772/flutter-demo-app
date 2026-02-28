import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "com.example.app",
                                              binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // This is where existing handlers would be, or a default FlutterMethodNotImplemented
      // If you have a 'switch call.method' statement, add this case to it.
      // If you have an 'if call.method == "someMethod"' chain, add an 'else if call.method == "getBatteryLevel"' branch.
      // If the MethodChannel handler is bare or only calls result(FlutterMethodNotImplemented), wrap it in a 'switch' block.
      // For example, if you have:
      //     batteryChannel.setMethodCallHandler { call, result ->
      //         result(FlutterMethodNotImplemented)
      //     }
      // You should replace it with:
      //     batteryChannel.setMethodCallHandler { call, result ->
      //         switch call.method {
      //             case "getBatteryLevel":
      //                 UIDevice.current.isBatteryMonitoringEnabled = true
      //                 result(Int(UIDevice.current.batteryLevel * 100))
      //             default:
      //                 result(FlutterMethodNotImplemented)
      //         }
      //     }
      // The code below represents the 'getBatteryLevel' case to be inserted into an existing MethodChannel handler.
      switch call.method {
      case "getBatteryLevel":
          UIDevice.current.isBatteryMonitoringEnabled = true
          result(Int(UIDevice.current.batteryLevel * 100))
      default:
          result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}