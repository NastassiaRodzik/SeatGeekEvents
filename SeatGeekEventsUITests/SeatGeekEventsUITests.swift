//
//  SeatGeekEventsUITests.swift
//  SeatGeekEventsUITests
//
//  Created by Анастасия Ковалева on 24.03.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import XCTest

class SeatGeekEventsUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testEventsSearch() {
        let app = XCUIApplication()
        let searchTextField = app.searchFields["Search Any Event"]
        searchTextField.tap()
        searchTextField.typeText("Eve")
        
        let eventsTableView = XCUIApplication().tables["EventsTableView"]
        let eventCells = eventsTableView.cells
        let predicate = NSPredicate(value: eventCells.count > 0)
        expectation(for: predicate, evaluatedWith: eventCells)
        waitForExpectations(timeout: 1.5)
        
    }

}
