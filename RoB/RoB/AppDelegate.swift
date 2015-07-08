//
//  AppDelegate.swift
//  RoB
//
//  Created by Alexander Mogavero on 22/06/2015.
//  Copyright (c) 2015 SSKL Apps. All rights reserved.
//

import UIKit
import CoreData
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var pushNotificationController : PushNotificationController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        println(UIScreen.mainScreen())
        
        Parse.enableLocalDatastore()
        
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        self.pushNotificationController = PushNotificationController()
        
        //Register for Push Notifications, for iOS 8 ONLY
        if application.respondsToSelector("registerUserNotificationSettings:") {
            
            let types:UIUserNotificationType = (.Alert | .Badge | .Sound)
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
         
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        else {
            //Register for Push Notifications before iOS 8 - PRE IOS 8 ONLY - CODE WILL NEVER RUN DUE TO SWIFT COMPATIBILITY
            application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
        }
        
        Parse.setApplicationId("99GW6RUkPEhWYF0NLpyjDg3UFiyf1fKo1htNAcAm", clientKey: "9kW7muuqBgmobOQlm1fXzz8oUg0K0m0Ov0gkfF1X")
        
        PFFacebookUtils.initializeFacebook()
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController:UIViewController
        
        if currentUser() != nil {
            
            initialViewController = pageController
            
            //initialViewController = storyboard.instantiateViewControllerWithIdentifier("PageController") as! UIViewController
        }
        else {
            initialViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
            
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        
        // Override point for customization after application launch.
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        println("Trying to Register User for Push Notifications in iOS 8")
        let currentInstallation = PFInstallation.currentInstallation()
        
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock{ (succeeded, e) -> Void in
        }
    }
    
    




    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error:NSError) {
        println("Failed to Register for Remote Notifications: (error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
    }
    
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }

    func applicationWillTerminate(application: UIApplication) {
        
        PFFacebookUtils.session()!.close()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

