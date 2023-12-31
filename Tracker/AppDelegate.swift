//
//  AppDelegate.swift
//  Tracker
//
//  Created by Александр Пичугин on 27.07.2023.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let analyticsService = AnalyticsService.shared
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        analyticsService.activate()
        
        window = UIWindow()
        if Constant.notFirstStart {
            window?.rootViewController = TabBarController()
        } else {
            UserDefaults.standard.set(true, forKey: "notFirstStart")
            window?.rootViewController = OnboardingViewController(transitionStyle: .scroll,
                                                                  navigationOrientation: .horizontal)
        }
        window?.makeKeyAndVisible()
        return true
    }
}
