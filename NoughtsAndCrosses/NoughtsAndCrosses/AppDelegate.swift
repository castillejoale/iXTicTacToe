//
//  AppDelegate.swift
//  NoughtsAndCrosses
//
//  Created by Julian Hulme on 2016/05/02.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var gameNavigationController: UINavigationController?
    var authorisationNavController: UINavigationController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let boardViewController = BoardViewController(nibName:"BoardViewController",bundle:nil)
        self.gameNavigationController = UINavigationController(rootViewController: boardViewController)
        self.gameNavigationController?.navigationBarHidden = true
        
        let landingViewController = LandingViewController(nibName: "LandingViewController", bundle: nil)
        self.authorisationNavController = UINavigationController(rootViewController: landingViewController)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //Set initial navController
        if let _ = UserController.sharedInstance.getLoggedInUser()   {
            self.window?.rootViewController = self.gameNavigationController
        }   else    {
            self.window?.rootViewController = self.authorisationNavController
        }
        
        self.window?.makeKeyAndVisible()
        
        EasterEggController.sharedInstance.initiate(self.window!)
        
        return true
    }
    
    func navigateToLoggedInNavigationController() {
        self.window?.rootViewController = self.gameNavigationController
    }
    
    func navigateToLoggedOutNavigationController() {
        self.authorisationNavController?.popToRootViewControllerAnimated(false)
        self.window?.rootViewController = self.authorisationNavController
    }

    //MARK: Easter Egg Function
    func navigateToEasterEggScreen  (animated:Bool) {
     
        let snapShot = self.window?.snapshotViewAfterScreenUpdates(true)
        let easterEggViewController = EasterEggViewController(nibName: "EasterEggViewController",bundle: nil)
        easterEggViewController.view.addSubview(snapShot!)
        
        UIView.transitionWithView(self.window!, duration: NSTimeInterval(1), options: UIViewAnimationOptions.CurveLinear, animations: { self.window?.rootViewController = easterEggViewController}, completion: nil)
        
        UIView.animateWithDuration(NSTimeInterval(1), animations: {snapShot?.layer.opacity = 0; snapShot?.layer.transform =  CATransform3DMakeScale(1.5, 1.5, 1.5)})
        
    }
    
    func returnToMainNavigationController() {
        
        let snapShot = self.window?.snapshotViewAfterScreenUpdates(true)
        
        self.gameNavigationController?.visibleViewController!.view.addSubview(snapShot!)
        
        UIView.transitionWithView(self.window!, duration: NSTimeInterval(2), options: UIViewAnimationOptions.CurveLinear, animations: {
            
            if (UserController.sharedInstance.getLoggedInUser() != nil) {
                self.window?.rootViewController = self.gameNavigationController
            } else {
                self.window?.rootViewController = self.authorisationNavController
            }
            
        }, completion: nil)
        
        UIView.animateWithDuration(NSTimeInterval(2), animations: {snapShot?.layer.opacity = 0; snapShot?.layer.transform =  CATransform3DMakeScale(1.5, 1.5, 1.5)})
        
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
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

