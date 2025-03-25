//
//  SceneDelegate.swift
//
//
//  Created by Jamaluddin Syed on 09/01/23.
//

import UIKit
import AdSupport
import AppTrackingTransparency

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var adv_id: String?
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        window?.makeKeyAndVisible()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window = window
        }
    }
    
    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        print("active")
        
        requestIDFA()
    }
    
    
    
    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        print("display foreground")
        
        if !UserDefaults.standard.bool(forKey: "run_appdelegate") && UserDefaults.standard.bool(forKey: "passcheck") {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let mainTabController = storyboard.instantiateViewController(withIdentifier: "lockPass") as?  LockPassCodeViewController {
                
                if let rootViewController = window?.windowScene?.windows.first?.rootViewController {
                    rootViewController.modalPresentationStyle = .overCurrentContext
                    UserDefaults.standard.set("scene", forKey: "lockSource")
                    rootViewController.present(mainTabController, animated: true, completion: {
                        mainTabController.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
                    })
                }
            }
        }
    }
    
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        
        
    }
    
    func requestIDFA() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        let advertise = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        print(advertise)
                        self.adv_id = advertise
                        print("enable tracking")
                    case .denied:
                        let advertise = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        print(advertise)
                        self.adv_id = advertise
                        print("disable tracking")
                    case .notDetermined:
                        let advertise = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        print(advertise)
                        self.adv_id = advertise
                        print("not determined")
                    case .restricted:
                        let advertise = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        print(advertise)
                        self.adv_id = advertise
                        print("restricted")
                    default:
                        let advertise = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        print(advertise)
                        self.adv_id = advertise
                        print("default case")
                    }
                }
            }
        }
    }
}
