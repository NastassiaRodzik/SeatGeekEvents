//
//  EventCoordinator.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit

struct EventCoordinator: Coordinator {
    
    private let eventViewModel: EventViewModelProtocol
    private let viewController: UIViewController
    
    init(eventViewModel: EventViewModelProtocol,
         viewController: UIViewController) {
        self.eventViewModel = eventViewModel
        self.viewController = viewController
    }
    
    func start() {
        let viewModel = EventDetailViewModel(eventViewModel: eventViewModel, favoritesManager: FavoritesManager())
        let eventController = EventViewController(viewModel: viewModel)
        viewController.present(eventController, animated: true)
        
    }
    
}
