//
//  EventDetailViewModel.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/24/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

protocol EventViewModel {
   
    var isFavorite: Observable<Bool> { get }
    var eventViewModel: EventViewModelProtocol { get }
    
    func favouriteButtonTapped()
}

struct EventDetailViewModel: EventViewModel {

    let isFavorite: Observable<Bool>
    var eventViewModel: EventViewModelProtocol
    
    private let favoritesManager: FavoritesHandler
    private let disposeBag = DisposeBag()
    
    init(eventViewModel: EventViewModelProtocol, favoritesManager: FavoritesHandler) {
        self.eventViewModel = eventViewModel
        self.favoritesManager = favoritesManager
        
        isFavorite = Observable<Bool>(eventViewModel.isFavorite.value)
        isFavorite
            .bind(to: eventViewModel.isFavorite)
            .dispose(in: disposeBag)
    }
    
    func favouriteButtonTapped() {
        let eventIdentifier = eventViewModel.identifier
        if isFavorite.value {
            favoritesManager.removeFromFavorite(eventIdentifier: eventIdentifier)
            isFavorite.value = false
        } else {
            favoritesManager.makeFavorite(eventIdentifier: eventIdentifier)
            isFavorite.value = true
        }
    }
}

