/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    WallPost.registerSubclass()
    
    let configuration = ParseClientConfiguration {
      $0.applicationId = "sfasfsfa999999817781"
      $0.server = "http://breakout-aug.herokuapp.com/parse"
    }
    Parse.initialize(with: configuration)
    /*
    //1
    let userNotificationCenter = UNUserNotificationCenter.current()
    userNotificationCenter.delegate = self
    
    //2
    userNotificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { accepted, error in
      guard accepted == true else {
        print("User declined remote notifications")
        return
      }
      //3
      application.registerForRemoteNotifications()
    }
    */
    return true
  }
  
  // 1
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let installation = PFInstallation.current()
    installation?.setDeviceTokenFrom(deviceToken)
    installation?.saveInBackground()
  }
  // 2
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    if (error as NSError).code == 3010 {
      print("Push notifications are not supported in the iOS Simulator.")
    } else {
      print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
    }
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler:
    @escaping (UNNotificationPresentationOptions) -> Void) {
    PFPush.handle(notification.request.content.userInfo)
    completionHandler(.alert)
  }
}
