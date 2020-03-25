//
//  AppDelegate.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 24.03.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var appCoordinator: EventsCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            appCoordinator = EventsCoordinator(window: window)
            appCoordinator.start()
        }
        return true
    }


}

