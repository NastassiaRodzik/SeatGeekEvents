//
//  DuplicatesFilterTests.swift
//  SeatGeekEventsTests
//
//  Created by Анастасия Ковалева on 3/30/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import XCTest
@testable import SeatGeekEvents

class DuplicatesFilterTests: XCTestCase {
    
    private var duplicatesFilter: DuplicatesFilter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        duplicatesFilter = EventsDuplicatesFilter()
    }

    override func tearDownWithError() throws {
        duplicatesFilter = nil
        
        try super.tearDownWithError()
    }

    func testDuplicatesInBatchFilter() throws {
        let events: [IntIdentifiable] = [EventMock(identifier: 1, title: "First Event"),
                      EventMock(identifier: 2, title: "Second Event"),
                      EventMock(identifier: 3, title: "Third Event"),
                      EventMock(identifier: 3, title: "Fifth Event")
        ]
        let filteredEvents = duplicatesFilter.filterDuplicates(from: events)
        XCTAssert(filteredEvents.count == 3, "Duplicates should be filtered")
    }
    
    func testDuplicatesFilter() throws {
        let events: [IntIdentifiable] = [EventMock(identifier: 1, title: "First Event"),
                      EventMock(identifier: 2, title: "Second Event"),
                      EventMock(identifier: 3, title: "Third Event"),
                      EventMock(identifier: 5, title: "Fifth Event")
        ]
        let _ = duplicatesFilter.filterDuplicates(from: events)
        let newEvents: [IntIdentifiable] = [EventMock(identifier: 1, title: "First Event"),
                      EventMock(identifier: 2, title: "Second Event"),
                      EventMock(identifier: 3, title: "Third Event"),
                      EventMock(identifier: 5, title: "Fifth Event")
        ]
        let filteredNewEvents = duplicatesFilter.filterDuplicates(from: newEvents)
        
        XCTAssert(filteredNewEvents.count == 0, "Duplicates should be filtered")
    }
    
    func testDifferentEventsFilter() throws {
        let events: [IntIdentifiable] = [EventMock(identifier: 1, title: "First Event"),
                      EventMock(identifier: 2, title: "Second Event"),
                      EventMock(identifier: 3, title: "Third Event"),
                      EventMock(identifier: 5, title: "Fifth Event")
        ]
        let filteredEvents = duplicatesFilter.filterDuplicates(from: events)
        XCTAssert(filteredEvents.count == events.count, "All events are different")
        let newEvents: [IntIdentifiable] = [EventMock(identifier: 6, title: "Sixth Event"),
                      EventMock(identifier: 7, title: "Seventh Event"),
                      EventMock(identifier: 8, title: "Eighth Event"),
                      EventMock(identifier: 9, title: "Ninth Event")
        ]
        let filteredNewEvents = duplicatesFilter.filterDuplicates(from: newEvents)
        
        XCTAssert(filteredNewEvents.count == newEvents.count, "All new events are different")
    }


}
