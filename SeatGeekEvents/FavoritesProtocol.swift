//
//  FavoritesHandler.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

protocol FavoritesHandler {
    func isFavorite(eventIdentifier: Int) -> Bool
    
    func makeFavorite(eventIdentifier: Int)
    func removeFromFavorite(eventIdentifier: Int)
}
