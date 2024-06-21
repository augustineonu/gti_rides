import UIKit
import Flutter
import Intercom

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    Intercom.setApiKey("ios_sdk-efac9e9f5fa7bf1e1bfb33d91f1cddd68b47f895", forAppId: "hivazykc")
    Intercom.setLauncherVisible(false)
    Intercom.loginUnidentifiedUser()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
