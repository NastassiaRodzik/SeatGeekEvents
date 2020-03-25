//
//  FavoritesDataStore.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

protocol FavoritesDataStore {
    
    func getAllFavorites() -> [Int]
    func saveFavorites(favouriteEventIds: [Int])
    
}
