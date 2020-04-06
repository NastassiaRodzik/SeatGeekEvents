//
//  Connectivity.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 4/6/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation
import Bond
import Reachability

protocol ConnectivityManager {
    
    var isConnected: Observable<Bool> { get }
    
}

class ReachabilityManager: ConnectivityManager {
    var isConnected: Observable<Bool>
    
    private let reachability: Reachability
    
    deinit {
        reachability.stopNotifier()
    }
    
    init() {
        isConnected = Observable<Bool>(true)
        
        reachability = try! Reachability()

        reachability.whenReachable = { [weak self] _ in
            guard let self = self else { return }
            self.isConnected.value = true
        }
        reachability.whenUnreachable = { [weak self] _ in
            guard let self = self else { return }
            self.isConnected.value = false
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
}
