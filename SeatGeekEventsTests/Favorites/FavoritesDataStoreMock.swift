//
//  FavoritesDataStoreMock.swift
//  SeatGeekEventsTests
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

class FavoritesDataStoreMock: FavoritesDataStore {
    private var favorites: [Int] = []
    
    func getAllFavorites() -> [Int] {
        return favorites
    }
    
    func saveFavorites(favouriteEventIds: [Int]) {
        self.favorites = favouriteEventIds
    }
}
