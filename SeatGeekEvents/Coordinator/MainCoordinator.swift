//
//  MainCoordinator.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit

class EventsCoordinator: Coordinator {

    private let window: UIWindow
    private var viewController: UIViewController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewModel = EventsListViewModel()
        let eventsListViewController = EventsListViewController(viewModel: viewModel)
        self.viewController = eventsListViewController
        
        let _ = viewModel.nextEventToDisplay.observeNext { [weak self] eventViewModel in
            guard let self = self else { return }
            guard let eventViewModel = eventViewModel else { return }
            self.showEvent(with: eventViewModel)
        }
        
        window.rootViewController = self.viewController
        window.makeKeyAndVisible()
    }
    
    func showEvent(with viewModel: EventTableViewCellViewModelProtocol) {
        guard let viewController = viewController else { return }
        let eventCoordinator = EventCoordinator(eventViewModel: viewModel, viewController: viewController)
        eventCoordinator.start()
    }
    
}
