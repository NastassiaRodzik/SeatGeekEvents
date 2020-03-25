//
//  FavoriteEventsTests.swift
//  SeatGeekEventsTests
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import XCTest
@testable import SeatGeekEvents

class FavoriteEventsTests: XCTestCase {

    var favoritesManager: FavoritesHandler!
    
    override func setUpWithError() throws {
        let dateStore = FavoritesDataStoreMock()
        favoritesManager = FavoritesManager(favoritesDataStore: dateStore)
    }

    override func tearDownWithError() throws {
        favoritesManager = nil
        try super.tearDownWithError()
    }

    func testAddingToFavorites() throws {
        let newFavoriteEventId = 100
        favoritesManager.makeFavorite(eventIdentifier: newFavoriteEventId)
        XCTAssertTrue(favoritesManager.isFavorite(eventIdentifier: newFavoriteEventId), "\(newFavoriteEventId) was just added to Favorites")
    }
    
    func testRemovingFromFavorites() throws {
        let newFavoriteEventId = 101
        favoritesManager.makeFavorite(eventIdentifier: newFavoriteEventId)
        favoritesManager.removeFromFavorite(eventIdentifier: newFavoriteEventId)
        XCTAssertTrue(!favoritesManager.isFavorite(eventIdentifier: newFavoriteEventId), "\(newFavoriteEventId) was just removed from Favorites")
    }

}
