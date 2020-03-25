//
//  FavoritesManager.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

class FavoritesManager: FavoritesHandler {
    
    private let favoritesStore: FavoritesDataStore
    private var favoriteEventIds: [Int]
    
    init(favoritesDataStore: FavoritesDataStore = UserDefaultsFavoritesDataStore()) {
        favoritesStore = favoritesDataStore
        favoriteEventIds = favoritesDataStore.getAllFavorites()
    }
    
    func makeFavorite(eventIdentifier: Int) {
        favoriteEventIds.append(eventIdentifier)
        backupFavorites()
    }
    
    func removeFromFavorite(eventIdentifier: Int) {
        guard let eventIdentifierIndex = favoriteEventIds.index(of: eventIdentifier) else { return }
        favoriteEventIds.remove(at: eventIdentifierIndex)
        backupFavorites()
    }
    
    func isFavorite(eventIdentifier: Int) -> Bool {
        return favoriteEventIds.contains(eventIdentifier)
    }
    
    private func backupFavorites() {
        favoritesStore.saveFavorites(favouriteEventIds: favoriteEventIds)
    }
    
}
