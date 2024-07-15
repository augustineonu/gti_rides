import UIKit
import Flutter
import Intercom
import Firebase
// import FirebaseCore
// import FirebaseAuth
// import GoogleSignIn

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //  // Add the following line, with your specific Firebase options:
    // if #available(iOS 10.0, *) {
    //   UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    // }
    // FirebaseApp.configure()
    // application.registerForRemoteNotifications()
    // // added content end
    // FirebaseApp.configure()
    Intercom.setApiKey("ios_sdk-efac9e9f5fa7bf1e1bfb33d91f1cddd68b47f895", forAppId: "hivazykc")
    Intercom.setLauncherVisible(false)
    Intercom.loginUnidentifiedUser()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  // @available(iOS 9.0, *)
  // func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
  //   return GIDSignIn.sharedInstance.handle(url)
  // }
}
