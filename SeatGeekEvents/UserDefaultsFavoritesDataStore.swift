//
//  UserDefaultsFavoritesDataStore.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

private enum UserDefaultsKey {
    static let favorites = "Favorites"
}

struct UserDefaultsFavoritesDataStore: FavoritesDataStore {
    
    func getAllFavorites() -> [Int] {
        return UserDefaults.standard.array(forKey: UserDefaultsKey.favorites) as? [Int] ?? []
    }
    
    func saveFavorites(favouriteEventIds: [Int]) {
        UserDefaults.standard.set(favouriteEventIds, forKey: UserDefaultsKey.favorites)
    }
    
}
