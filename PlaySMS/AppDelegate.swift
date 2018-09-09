//
//  AppDelegate.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 12/31/16.
//  Copyright © 2016 Sully. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate  {

    var window: UIWindow?
    @objc let gcmMessageIDKey = "gcm.message_id"
    
 
    struct GlobalVariable {
        static var deviceTokenGlobal: String = ""
        
    }
    @objc var deviceToken: String = ""
    
    
    //hooking to cLoudstore
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //TODO: Initialise and Configure your Firebase here:
        //TODO: uncomment notfication section when ready to use again...ees
        //enabling Google Auth
        
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        
        //MARK: Notifications
      
       

        
        
      Messaging.messaging().delegate = self as MessagingDelegate

        Messaging.messaging().shouldEstablishDirectChannel = true
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, tob
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
         // [END register_for_notifications]

        //MARK: Notifications END
        return true
    }

    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            
            print("Message ID: \(messageID)")
            UIApplication.shared.applicationIconBadgeNumber = 0     //ees... Set Icon badge count to 0 when app loads
            
          
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            UIApplication.shared.applicationIconBadgeNumber = 0     //ees... Set Icon badge count to 0 when app loads
            
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    

    
    // [END receive_message]
    
    
    //**********************************************
    //MARK: Enabling google sign in...ees
    //**********************************************
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
//    func sign(_ signin: GIDSignIn!, didSignOutFor user: GIDGoogleUser!, withError error: Error?) {
//        
//    }
//    
    
    //google signin for "didsignin"...ees
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                
                print(error.localizedDescription)
                return
            }
            // User is signed in
            //now to update the ExtendedUserDB with the fcmToken from this device for the logged in email
            let currentUser = Auth.auth().currentUser!.email
            UserDefaults.standard.set(currentUser, forKey: "AppUserName")
            //sleep(1)
           
           
            let userDB = Firestore.firestore()
            let settings = userDB.settings
            settings.areTimestampsInSnapshotsEnabled = true
            userDB.settings = settings
            
            //let deviceTokenIn = AppDelegate.GlobalVariable.deviceTokenGlobal
            
            userDB.collection("userFcmtokens")
                
                .whereField("email", isEqualTo: currentUser!)
                //.whereField("fcmToken", isEqualTo: "asdfg")   //TODO: need to get the current fcmtoken for querying
                
                .whereField("fcmToken", isEqualTo: self.deviceToken)   //TODO: need to get the current fcmtoken for querying
                
                .getDocuments() { (querySnapshot, err) in
                    
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        
                        if querySnapshot?.count == 0 {
                            //fcmtoken is not present SO INSERT IT
                            
                            var ref: DocumentReference? = nil
                            ref = userDB.collection("userFcmtokens").addDocument(data: [
                                "email": currentUser!,
                                "fcmToken": self.deviceToken
                                
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    print("Document added with ID: \(ref!.documentID)")
                                }
                            }

                            
                            
                        }  //end query snapshot == nil
                        
                        //now we have a match and just to make sure we will delete each one that matches
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                        }
                    }
                } //endgetdocuments
            
            
            
            
            
            
            
            
            
          
          
            
        }
        // ...
    }
    
   
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
      
    }
    
    //**********************************************
    //MARK: Enabling Registration for notifications
    //**********************************************
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
    }
    
      

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0     //ees... Set Icon badge count to 0 when app loads
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    

    func applicationDidFinishLaunching(_ application: UIApplication)
    {
        Thread.sleep(forTimeInterval: 2)
    }
    
    

}

//now for extensions

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        //set global deviceToken for use with userdb
        self.deviceToken = fcmToken
        GlobalVariable.deviceTokenGlobal = fcmToken

        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received Internal data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}



