//
//  AppDelegate.swift
//  NewsFun
//
//  Created by zappycode on 4/27/18.
//  Copyright © 2018 Nick Walter. All rights reserved.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "NewsApp.refresh",
            using: DispatchQueue.global()
        ) { task in
            self.handleAppRefresh(task)
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
        
        scheduleAppRefresh()
        print("Application entered background.")
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "NewsApp.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 30 * 60) // App Refresh after 30 minutes.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
            print("BackgroundRefreshTask scheduled for 30 mins.")
        } catch {
            print("Could not schedule app refresh: (error)")
        }
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
    
    func appRefresh(){
        
        if let viewController = window?.rootViewController as? ArticleTableViewController {
            viewController.getArticles()
        }
    }

    private func handleAppRefresh(_ task: BGTask) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        
        //let appRefreshOperation = AppRefreshOperation()
        queue.addOperation(appRefresh)
        
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        let lastOperation = queue.operations.last
        lastOperation?.completionBlock = {
            task.setTaskCompleted(success: !(lastOperation?.isCancelled ?? false))
        }
        
        scheduleAppRefresh()
    }
    
}

