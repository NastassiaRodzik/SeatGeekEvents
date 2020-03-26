//
//  MainCoordinator.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit
import ReactiveKit

class EventsCoordinator: Coordinator {

    private let window: UIWindow
    private var viewController: UIViewController?
    
    private let disposeBag = DisposeBag()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewModel = EventsListViewModel()
        let eventsListViewController = EventsListViewController(viewModel: viewModel)
        self.viewController = eventsListViewController
        
        let eventDisposable = viewModel.nextEventToDisplay.observeNext { [weak self] eventViewModel in
            guard let self = self else { return }
            guard let eventViewModel = eventViewModel else { return }
            self.showEvent(with: eventViewModel)
        }
        
        let errorDisposable = viewModel.error.observeNext { [weak self] error in
            DispatchQueue.main.async { [weak self] in
                self?.presentError(error)
            }
        }
        
        [eventDisposable, errorDisposable].forEach({ $0.dispose(in: disposeBag) })
        
        window.rootViewController = self.viewController
        window.makeKeyAndVisible()
    }
    
    func showEvent(with viewModel: EventViewModelProtocol) {
        guard let viewController = viewController else { return }
        let eventCoordinator = EventCoordinator(eventViewModel: viewModel, viewController: viewController)
        eventCoordinator.start()
    }
    
    private func presentError(_ error: Error?) {
        guard let error = error else { return }
        let message: String?
        if let localizedError = error as? LocalizedError {
            message = localizedError.errorDescription
        } else {
            message = error.localizedDescription
        }
        let alert = UIAlertController(title: NSLocalizedString("Cannot display data", comment: ""),
                                     message: message,
                                     preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                     style: .default)
        alert.addAction(okAction)
        viewController?.present(alert, animated: true, completion: nil)
    }
    
}
