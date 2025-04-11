//
//  AppDelegate.swift
//+
//
//  Created by Jamaluddin Syed on 09/01/23.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging
import UserNotificationsUI


@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            success, _ in
            
            guard success else {
                return
            }
        }
        
        application.registerForRemoteNotifications()
        
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardToolbarManager.shared.toolbarConfiguration.placeholderConfiguration.showPlaceholder = true
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        
        if !UserDefaults.standard.bool(forKey: "hasAppLaunchedOnce") {
            //app opened first time
            UserDefaults.standard.set(true, forKey: "hasAppLaunchedOnce")
        }
        
        else {
            //open
            UserDefaults.standard.set(true, forKey: "run_appdelegate")
        }
        
        return true
    }
    

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        messaging.token { token, _ in
            
            guard let token = token else {
                return
            }
            UserDefaults.standard.set(token, forKey: "fcm_token")
            
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if #available(iOS 14.0, *) {
            completionHandler(UNNotificationPresentationOptions.banner)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let id = response.notification.request.content.body
        let order_id = String(id.suffix(13))
        let method = id.components(separatedBy: " ")
        let odm = method.first ?? ""
        
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController
        else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NewOrderDetailVC") as! NewOrderDetailVC
        controller.order_id = order_id
        controller.mode = "notify"
        controller.live_status = "Accepted"
        controller.order_method = odm
        rootViewController.present(controller, animated: true)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed registration")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
            print("did become active")
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        print("update screen")
    }

    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "MApp")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                 
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
    //Reporting
//        UserDefaults.standard.set(101, forKey: "tempDateTimeFilter_sales")
//        UserDefaults.standard.set(101, forKey: "tempDateTimeFilter_item")
//        UserDefaults.standard.set(101, forKey: "tempDateTimeFilter_order")
//        UserDefaults.standard.set(101, forKey: "tempDateTimeFilter_taxes")
//
//        UserDefaults.standard.set(0, forKey: "tempOrderSource_sales")
//        UserDefaults.standard.set(0, forKey: "tempOrderSource_item")
//        UserDefaults.standard.set(0, forKey: "tempOrderSource_order")
//        UserDefaults.standard.set(0, forKey: "tempOrderSource_taxes")
//
//        UserDefaults.standard.set(0, forKey: "tempOrderType_sales")
//        UserDefaults.standard.set(0, forKey: "tempOrderType_item")
//        UserDefaults.standard.set(0, forKey: "tempOrderType_taxes")
//
//        UserDefaults.standard.set(0, forKey: "tempCategory_item")
//
//        UserDefaults.standard.set(101, forKey: "dateTimeFilter_sales")
//        UserDefaults.standard.set(101, forKey: "dateTimeFilter_item")
//        UserDefaults.standard.set(101, forKey: "dateTimeFilter_order")
//        UserDefaults.standard.set(101, forKey: "dateTimeFilter_taxes")
//
//        UserDefaults.standard.set(0, forKey: "validOrderSource_sales")
//        UserDefaults.standard.set(0, forKey: "validOrderSource_item")
//        UserDefaults.standard.set(0, forKey: "validOrderSource_order")
//        UserDefaults.standard.set(0, forKey: "validOrderSource_taxes")
//
//        UserDefaults.standard.set(0, forKey: "validOrderType_sales")
//        UserDefaults.standard.set(0, forKey: "validOrderType_item")
//        UserDefaults.standard.set(0, forKey: "validOrderType_taxes")
//
//        UserDefaults.standard.set(0, forKey: "validCategory_item")
//
//        UserDefaults.standard.set(0, forKey: "changeOrderSource_sales")
//        UserDefaults.standard.set(0, forKey: "changeOrderSource_item")
//        UserDefaults.standard.set(0, forKey: "changeOrderSource_order")
//        UserDefaults.standard.set(0, forKey: "changeOrderSource_taxes")
//
//        UserDefaults.standard.set(0, forKey: "changeOrderType_sales")
//        UserDefaults.standard.set(0, forKey: "changeOrderType_item")
//        UserDefaults.standard.set(0, forKey: "changeOrderType_taxes")
//
//        UserDefaults.standard.set(0, forKey: "changeCategory_item")
//
//        UserDefaults.standard.set("9", forKey: "orderSource_sales")
//        UserDefaults.standard.set("9", forKey: "orderSource_item")
//        UserDefaults.standard.set("9", forKey: "orderSource_order")
//        UserDefaults.standard.set("9", forKey: "orderSource_taxes")
//
//        UserDefaults.standard.set("both", forKey: "orderType_sales")
//        UserDefaults.standard.set("both", forKey: "orderType_item")
//        UserDefaults.standard.set("both", forKey: "orderType_taxes")
//
//        UserDefaults.standard.set("all", forKey: "category_item")
//
//        //Setup
//
//        UserDefaults.standard.set(10, forKey: "vendorDateMode")
//        UserDefaults.standard.set(1, forKey: "vendorDate")

}

