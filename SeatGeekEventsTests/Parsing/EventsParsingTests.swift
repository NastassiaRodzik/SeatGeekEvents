//
//  EventsParsingTests.swift
//  SeatGeekEventsTests
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import XCTest

class EventsParsingTests: XCTestCase {

    private var parser: EventsParser!
    
    override func setUp() {
        super.setUp()
        parser = EventsJSONParser()
    }

    override func tearDown() {
        parser = nil
        super.tearDown()
    }

    
    func testValidJSON() {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "events", withExtension: "json") else {
            XCTFail("Missing file: events.json")
            return
        }
        guard let jsonData = try? Data(contentsOf: url) else {
            XCTFail("events.json has wrong format")
            return
        }
        
        let events = parser.parseItems(from: jsonData)
        XCTAssert(events != nil && !events!.events.isEmpty, "Events should be parsed correctly")
    }
    
    func testInvalidJSON() {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "eventsInvalid", withExtension: "json") else {
            XCTFail("Missing file: eventsInvalid.json")
            return
        }
        guard let jsonData = try? Data(contentsOf: url) else {
            XCTFail("eventsInvalid.json has wrong format")
            return
        }
        
        let items = parser.parseItems(from: jsonData)
        XCTAssert(items == nil, "Items are in invalid format")
    }

}
