//
//  AppDelegate.swift
//  GoPatry
//
//  Created by Admin on 07.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Firebase
import FBSDKShareKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override init() {
        super.init()
    
        //Model()
        
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        //print("URL : ")
        
        FBSDKApplicationDelegate.sharedInstance().application( application, didFinishLaunchingWithOptions: nil)
        if FBSDKAccessToken.current() != nil {
            FacebookHelper.getInstance().setTokenAndGetMe(token: FBSDKAccessToken.current())
        }
        
        return true
    }
    func application(_ application: UIApplication, openURL url: NSURL, sourceApplication: String?,
                     annotation: AnyObject?) -> Bool {
        
        print("URL : \(url)")
        if(url.scheme!.isEqual("fb151724738572175")) {
            print("Facebook url scheme")
            
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                open: url as URL!,
                sourceApplication: sourceApplication,
                annotation: annotation)
            
        }
        
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        self.customNavigationBar()
//        if (!isIcloudAvailable()) {
//            self.displayAlertWithTitle("iCloud", message: "iCloud is not available." +
//                " Please sign into your iCloud account and restart this app")
//            return true
//        }
//        
//        if (FBSDKAccessToken.currentAccessToken() != nil) {
//            self.instantiateViewController("MapViewController", storyboardIdentifier: "Main")
//        }
       
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?, _: CTRubyAnnotation) -> Bool {
        
        print("SDK version \(FBSDKSettings .sdkVersion())")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //AppDelegate.TheModel = Model()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        FBSDKAppEvents.activateApp()
       
        //FacebookHelper.getInstance().setToken(token: FBSDKAccessToken.current())
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
        
        //FBSDKApplicationDelegate.sharedInstance().application( application, didFinishLaunchingWithOptions: nil)
        //FacebookHelper.getInstance().setToken(token: FBSDKAccessToken.current())
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        Model()
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        
        // doesnt work
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.lightGray], for: .normal)
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.lightGray], for: .selected)
        
        //        init(hex: 0xFFFFFF)
    }

}

