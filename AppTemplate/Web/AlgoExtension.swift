
import Foundation
import UIKit
import FirebaseCore
import FirebaseMessaging


extension AppDelegate : UNUserNotificationCenterDelegate, MessagingDelegate
{
    func decide(fcmToken: String) async -> Bool
    {
        await WebManager.decide(finalUrl: formulateRequest(initialUrl: WebManager.initialURL, fcmToken: fcmToken))
        return WebManager.provenUrl != nil
    }
    
    func onPositivelyDecided()
    {
        let contentView = CustomHostingController(rootView: WebView(url: WebManager.provenUrl!))
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = contentView
        OrientationHelper.orientaionMask = UIInterfaceOrientationMask.all
        OrientationHelper.isAutoRotationEnabled = true
        window?.makeKeyAndVisible()
    }
    
    func formulateRequest(initialUrl: String, fcmToken: String) async -> String
    {
        if initialUrl.contains("?")
        {
            return "\(initialUrl)&fcm=\(fcmToken)"
        }
        else
        {
            return "\(initialUrl)?fcm=\(fcmToken)"
        }
    }
    
    func initApp()
    {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("🔔 Notification permission granted: \(granted)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.application?.registerForRemoteNotifications()
            }
        }
    }
    
    func onPushRecieved(content: [AnyHashable: Any])
    {
        print("Push recieved")
        print(content)
        if let url = content["url"] as? String
        {
            if let url = URL(string: url)
            {
                WebManager.provenUrl = url
                onPositivelyDecided()
            }
            else
            {
                print("Incorrect url format")
            }
        }
        else
        {
            print("No url string in push")
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM token updated: \(fcmToken ?? "nil")")
        
        //        if let fcmToken = fcmToken {
        //            onTokenRecieved(token: fcmToken)
        //        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DeviceToken: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { token, error in
            if let error = error {
                print("❌ Error fetching FCM token: \(error)")
                self.onGameStart()
            } else if let token = token {
                self.onTokenRecieved(token: token)
            }
        }
    }
    
    func onTokenRecieved(token: String)
    {
        Task {
            if await !self.decide(fcmToken: token) {
                self.onGameStart()
            }
            else
            {
                self.onPositivelyDecided()
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for remote notifications: \(error)")
        onGameStart()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        onPushRecieved(content: userInfo)
        
        completionHandler()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound])
    }
    
    func showLoadingScreen()
    {
        DispatchQueue.main.async {
            if let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil) as? UIStoryboard {
                if let loadingVC = storyboard.instantiateInitialViewController() as? UIViewController {
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = loadingVC
                    self.window?.makeKeyAndVisible()
                    // find element with id "logo" and add scale pulse animation to it
                    if let logo = loadingVC.view.viewWithTag(1) as? UIImageView {
                        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
                        pulseAnimation.duration = 1
                        pulseAnimation.fromValue = 1
                        pulseAnimation.toValue = 0.5
                        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                        pulseAnimation.autoreverses = true
                        pulseAnimation.repeatCount = .infinity
                        logo.layer.add(pulseAnimation, forKey: "pulse")
                    }
                }
            }
            else {
                print("Error: LaunchScreen storyboard not found")
            }
        }
    }
}
