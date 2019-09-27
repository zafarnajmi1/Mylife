//
//  AppDelegate.swift
//  SocialMedia
//
//  Created by Macbook on 03/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import CoreData
import Crashlytics
import Fabric
import IQKeyboardManagerSwift
import Material
import DropDown
import GoogleMaps
import GooglePlaces
import UIKit
import CoreData
import UserNotifications
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
import UserNotifications
import DropDown
import SocketIO
import GoogleMaps
import GooglePlaces
import FirebaseMessaging
import Firebase
import AVFoundation


extension UINavigationController {
    var rootViewController : UIViewController? {
        return viewControllers.first
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate
{
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    var defaults = UserDefaults.standard
    var deviceFcmToken = "0"
    var notification_count = 0
    let noti = ShareData.sharedUserInfo
    //static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let storyBoard = UIStoryboard.mainStoryboard
    
    let keyboardManager = IQKeyboardManager.shared
    let prefs = UserDefaults.standard
    let homeNavigationController = UIStoryboard.mainStoryboard.instantiateVC(HomeNavigationController.self)!
    
    lazy var leftViewController: LeftViewController = {
        return UIStoryboard.mainStoryboard.instantiateVC(LeftViewController.self)!
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        IQKeyboardManager.shared.enable = true
        //keyboardManager.enable = true
//UserDefaults.standard.set("ar", forKey: "i18n_language")
//        let lang = UserDefaults.standard.string(forKey: "i18n_language")  //menow
//
//
//        //moveToHome()
//
//        if lang == "ar" {
//
//
//            UIView.appearance().semanticContentAttribute = .forceRightToLeft
//
//        }
//        else {
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//        }
    
        //UserDefaults.standard.set("en", forKey: "i18n_language")
        
        DropDown.startListeningToKeyboard()
        
        Fabric.with([Crashlytics.self])
        
        if let controller = UIStoryboard.mainStoryboard.instantiateInitialViewController() {
            window?.rootViewController = controller
        } else {
            let navigationController = UINavigationController()
            window?.rootViewController = navigationController
        }
        
        customizeNavigationbar()
        
        customizeTabbar()
        
//        if (prefs.string(forKey: "useremail") != nil && prefs.string(forKey: "password") != nil)
//        {
//            moveToLoginController()
////            moveToHomeController()
//        }
//        else
//        {
//            moveToLoginController()
//        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set("0", forKey: "searchKey")
        userDefaults.synchronize()
        Fabric.with([Crashlytics.self])
        
        GMSServices.provideAPIKey("AIzaSyAjXgCiEiNnMTyp-Pa_BQO1nB7owjUQy9E")
        GMSPlacesClient.provideAPIKey("AIzaSyAjXgCiEiNnMTyp-Pa_BQO1nB7owjUQy9E")

        
        
        
        
        
        
        
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = UIColor(red:33/255, green:1/255, blue:50/255, alpha: 1)
//        }
//        UIApplication.shared.statusBarStyle = .lightContent
        
   
        
        
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        

        
        if #available(iOS 10, *)
        {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
            
        }
        else{
            UIApplication.shared.registerUserNotificationSettings (UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            
        }
        application.registerForRemoteNotifications()
        
        
        notification_count = 0
        UIApplication.shared.applicationIconBadgeNumber = notification_count
       // getUpdatedNotificationCountStatus()
        
        let fcmToken = Messaging.messaging().fcmToken
        defaults.set(fcmToken, forKey: "fcmToken")
        defaults.synchronize()
        
     
        
        //let token:String = Messaging.messaging().fcmToken!
        print(fcmToken)
        
        //Crash Manager
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func loginUser() {
        
        
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        let homeNavigationController = UIStoryboard.mainStoryboard.instantiateVC(HomeNavigationController.self)!
        let leftViewController: LeftViewController = {
            return UIStoryboard.mainStoryboard.instantiateVC(LeftViewController.self)!
        }()
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft

            let homeController = AppNavigationDrawerController(rootViewController: homeNavigationController, leftViewController: nil, rightViewController: leftViewController)
            let homeTabController = homeNavigationController.rootViewController as! MainHomeTabController
            homeTabController.navigationDrawer = homeController
            leftViewController.delegate = homeTabController
            
            let navigationController = UINavigationController(rootViewController: homeController)
            navigationController.navigationBar.isHidden = true
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
           // self.present(navigationController, animated: false, completion: nil)
        }
        else {
            
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            let homeController = AppNavigationDrawerController(rootViewController: homeNavigationController, leftViewController: leftViewController, rightViewController: nil)
            let homeTabController = homeNavigationController.rootViewController as! MainHomeTabController
            homeTabController.navigationDrawer = homeController
            leftViewController.delegate = homeTabController
            
            let navigationController = UINavigationController(rootViewController: homeController)
            navigationController.navigationBar.isHidden = true
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
            //self.present(navigationController, animated: false, completion: nil)
        }
        
        
    }
    
    func moveToHome() {
        
        //let mainController = storyBoard.instantiateViewController(withIdentifier: "MainHomeTabController") as! MainHomeTabController
        
        let tabController = self.storyBoard.instantiateViewController(withIdentifier: "MainHomeTabController") as! MainHomeTabController
        //   logininController.showAnimation = showAnimation
       
        
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        
        
        
        if lang == "ar" {
            
            
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
            let nvc: UINavigationController = UINavigationController (rootViewController: tabController)
            self.window?.rootViewController = nvc
            self.window?.makeKeyAndVisible()
            

        }
        else {
            
            
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
            let nvc: UINavigationController = UINavigationController (rootViewController: tabController)
            self.window?.rootViewController = nvc
            self.window?.makeKeyAndVisible()
            
            
//            let leftViewController = storyBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
//            let nvc: UINavigationController = UINavigationController(rootViewController: mainController)
//            let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
//            self.window?.rootViewController = slideMenuController
        }
        self.window?.makeKeyAndVisible()
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
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SocialMedia")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}

extension AppDelegate {
    
    func moveToLoginController() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
    }
//    func moveToHomeController() {
//        let homeController = AppNavigationDrawerController(rootViewController: homeNavigationController, leftViewController: leftViewController, rightViewController: nil)
//
//        let homeTabController = homeNavigationController.rootViewController as! MainHomeTabController
//        homeTabController.navigationDrawer = homeController
//        leftViewController.delegate = homeTabController
//
//        window?.rootViewController = homeController
//        window?.makeKeyAndVisible()
//    }
    
//    func pushToHomeController() {
//        let homeController = AppNavigationDrawerController(rootViewController: homeNavigationController, leftViewController: leftViewController, rightViewController: nil)
//        let homeTabController = homeNavigationController.rootViewController as! MainHomeTabController
//        homeTabController.navigationDrawer = homeController
//        leftViewController.delegate = homeTabController
//        let navigationController = UINavigationController(rootViewController: homeController)
//        navigationController.navigationBar.isHidden = true
//        
//        let rootViewController = self.window?.rootViewController as! UINavigationController
//        
//        rootViewController.presentVC(navigationController)
//    }
    
    func customizeTabbar() {
        let appearence = UITabBar.appearance()
        appearence.tintColor = .primary
    }
    
    func customizeNavigationbar() {
        // NavigaitonBar Appearence
        let appearance = UINavigationBar.appearance()
        
        appearance.setBackgroundImage(UIImage(), for: .default)
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .primary
        appearance.isTranslucent = false
        appearance.tintColor = UIColor.white
        
        let fontSize = Constants.FontSize.navigationBarTitle
        
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: UIFont.Name.regular, size: fontSize)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        appearance.barTintColor = .primary
    }
    
    func transparentNavigationBar() {
        let appearance = UINavigationBar.appearance()
        
        appearance.setBackgroundImage(UIImage(), for: .default)
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .clear
        appearance.isTranslucent = false
        appearance.tintColor = UIColor.white
        
        let fontSize = Constants.FontSize.navigationBarTitle
        
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: UIFont.Name.regular, size: fontSize)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        appearance.barTintColor = .clear
    }
    
    func disableKeyboardManager(_ controller: UIViewController.Type) {
        disableToolbarOnKeyboard(controller: controller)
        disableDistanceHandling(controller: controller)
    }
    
    func disableToolbarOnKeyboard(controller: UIViewController.Type) {
        keyboardManager.disabledToolbarClasses.append(controller)
    }
    
    func disableDistanceHandling(controller: UIViewController.Type) {
        keyboardManager.disabledDistanceHandlingClasses.append(controller)
    }
    
    func enableTouchOnKeyboard(controller: UIViewController.Type) {
        keyboardManager.enabledTouchResignedClasses.append(controller)
    }
}

extension AppDelegate : MessagingDelegate
{
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")
        
        let token = Messaging.messaging().fcmToken
        defaults.set(token, forKey: "fcmToken")
        defaults.synchronize()
    }
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//
////        notification_count = notification_count + 1
////        UIApplication.shared.applicationIconBadgeNumber = notification_count
////
//
//
//        print("Received data message: \(remoteMessage.appData)")
//    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        #if PROD_BUILD
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #else
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #endif
        
        Messaging.messaging().apnsToken = deviceToken
        
        if let refreshedToken = InstanceID.instanceID().token() {
            print("Firebase: InstanceID token: \(refreshedToken)")
            self.deviceFcmToken = refreshedToken
            defaults.setValue(deviceFcmToken, forKey: "fcmToken")
            defaults.synchronize()
            print("Firebase: did refresh fcm token: \(deviceToken) with: \(deviceFcmToken)")
        } else {
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func application(_ application: UIApplication, didrequestAuthorizationRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        #if PROD_BUILD
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #else
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #endif
        
        Messaging.messaging().apnsToken = deviceToken
        
        let token = deviceToken.base64EncodedString()
        
        let fcmToken = Messaging.messaging().fcmToken
        print("Firebase: FCM token: \(fcmToken ?? "")")
        
        print("Firebase: found token \(token)")
        
        print("Firebase: found token \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Firebase: user info \(userInfo)")
        
        switch application.applicationState {
            
        case .active:
            postToNotificationObserver()
            
            break
            
        case .background, .inactive:
            break
        }
        
        let gcmMessageIDKey = "gcm.message_id"
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("mtech Message ID: \(messageID)")
        }
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
//    // MARK: Firebase Push Delegate
//    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
//        //PreferenceManager.instance.setFCMToken(token: fcmToken)
//        let defaults = UserDefaults.standard
//        defaults.setValue(fcmToken, forKey: "deviceToken")
//        defaults.synchronize()
//
//        print("Firebase: did refresh fcm token: \(fcmToken)")
//    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Firebase: message token: \(remoteMessage)")
        
        print("messaging:\(messaging)")
        print("didReceive Remote Message:\(remoteMessage.appData)")
        
        guard let data = try? JSONSerialization.data(withJSONObject: remoteMessage.appData, options: .prettyPrinted),
            let prettyPrinted = String(data: data, encoding: .utf8) else { return }
        print("Received direct channel message:\n\(prettyPrinted)")
    }
    
    
    @objc public func getUpdatedNotificationCountStatus() {
   //     getUnreadNotificationCount()
    }
    
    //MARK: - GET Unread Notification Count
    func getUnreadNotificationCount() {
        
        UserHandler.getUnreadNotificationCount(success: { (success) in
            
            if (success.statusCode == 200) {
                
                if success.data != nil {
                    String(success.data.unreadNotification!)
                    
                    UIApplication.shared.applicationIconBadgeNumber = success.data.unreadNotification!
                }
                else {
                    //  self.view.makeToast("You Have No New Notification", duration: 2.0, position: .center)
                    
                }
            }
            else
            {
                UIApplication.shared.applicationIconBadgeNumber = 0
                //self.view.makeToast(success.message, duration: 2.0, position: .center)
            }
        }) { (error) in
            UIApplication.shared.applicationIconBadgeNumber = 0
//            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.")
//
//            self.displayAlertMessage(String(describing: error!))
            
        }
    }
    
    func postToNotificationObserver() {
//        let notificationName = Notification.Name(Constants.pushNotificationObserverName)
//        NotificationCenter.default.post(name: notificationName, object: nil)
        
    }
}




