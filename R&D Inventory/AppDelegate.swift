//
//  AppDelegate.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 12/27/16.
//  Copyright © 2016 Aaron Liberatore. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FIRApp.configure()
        //FIRDatabase.database().persistenceEnabled = true

        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        if let user = FIRAuth.auth()?.currentUser {
            onSignInApproved(user: user)
        }

        return true
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
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                        sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                        annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        guard let authentication = user.authentication else {
            return
        }

        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                                     accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential) { (usr, error) in
            
            guard usr != nil else {
                return
            }

            self.onSignInApproved(user: user)
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                withError error: Error!) {

        CurrentUser.logOut()
    }
    
    private func onSignInApproved(user: GIDGoogleUser) {
        if let name = user.profile.name {
            CurrentUser.fullName = name
        }
        if let email = user.profile.email {
            CurrentUser.email = email
        }
        if let idToken = user.authentication.idToken {
            CurrentUser.googleUserId = idToken
        }
        navigateToInitialScreen()
    }

    private func onSignInApproved(user: FIRUser) {
        if let name = user.displayName {
            CurrentUser.fullName = name
        }
        if let email = user.email {
            CurrentUser.email = email
        }

        navigateToInitialScreen()
    }

    private func navigateToInitialScreen() {
        
        FirebaseDataManager.getProjects {
            projects in

            projects.count > 0 ? self.navigateToHome(project: projects[0]) :
                                 self.navigateToInitialSetup()

        }
    }
    
    private func navigateToInitialSetup() {

        let storyboard:UIStoryboard = UIStoryboard(name: "InitialProjectCreation", bundle: nil)
        
        let navigationController: UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        
        guard let vc = navigationController.viewControllers[0] as? CreateProjectViewController else {
            return
        }
        
        vc.isInitialForm = true
        
        self.window?.rootViewController = navigationController
    }

    private func navigateToHome(project: Project) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
        
        let tabBar: UITabBarController = storyboard.instantiateInitialViewController() as! UITabBarController
    
        guard let navController0 = tabBar.viewControllers![0] as? UINavigationController,let vc0 = navController0.topViewController as? TabBarViewController else {
            return
        }
        
        guard let navController1 = tabBar.viewControllers![1] as? UINavigationController, let vc1 = navController1.topViewController as? TabBarViewController else {
            return
        }
        
        guard let navController2 = tabBar.viewControllers![2] as? UINavigationController,
            let vc2 = navController2.topViewController as? TabBarViewController else {
                return
        }
        
        guard let navController3 = tabBar.viewControllers![3] as? UINavigationController,
            let vc3 = navController3.topViewController as? TabBarViewController else {
                return
        }
        
        vc0.didChangeProject(project: project)
        vc1.didChangeProject(project: project)
        vc2.didChangeProject(project: project)
        vc3.didChangeProject(project: project)
        
        self.window?.rootViewController = tabBar
    }
}

