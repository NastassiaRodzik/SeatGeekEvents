//
//  ItemsNetworkingServiceTest.swift
//  SeatGeekEventsTests
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import XCTest

class ItemsNetworkingServiceTest: XCTestCase {
    
    private var session: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [EventsURLProtocolMock.self]
        session = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        session = nil
        super.tearDown()
    }

    func testDataLoading() {
        let networkingService: NetworkClient = EventsClient()
        let networkingRoute: NetworkRouter = EventsRoute(searchString: "Texas", page: 1)
        
        let promise = expectation(description: "Loading events data")
        let completionBlock: (EventsResponse?, Error?) -> Void = { (eventsResponse, error) in
            if eventsResponse != nil {
                promise.fulfill()
            } else {
                XCTFail("Items data is expected but \(String(describing: error)) was catched")
            }
        }
        networkingService.performRequest(route: networkingRoute, session: session, completion: completionBlock)
        wait(for: [promise], timeout: 1)
        
    }
    
    func testBadStatusCodeError() {
        let networkingService: NetworkClient = EventsClient()
        let networkingRoute: NetworkRouter = NoClientInfoRouteMock()
        
        let promise = expectation(description: "Loading events data")
        let completionBlock: (EventsResponse?, Error?) -> Void = { (eventsResponse, error) in
            if eventsResponse != nil {
                XCTFail("No data can be received without required parameter")
            } else if error is BadStatusCodeError {
                promise.fulfill()
            }
        }
        networkingService.performRequest(route: networkingRoute, session: session, completion: completionBlock)
        wait(for: [promise], timeout: 1)
        
    }
    
    func testInvalidURL() {
        let networkingService: NetworkClient = EventsClient()
        let networkingRoute: NetworkRouter = InvalidURLRouteMock()
        
        let promise = expectation(description: "Loading events data")
        let completionBlock: (EventsResponse?, Error?) -> Void = { (eventsResponse, error) in
            if eventsResponse != nil {
                XCTFail("No data can be received from invalid url")
            } else if let networkError = error as? NetworkError {
                 switch networkError {
                   case .invalidResponse, .noDataAvailable:
                       XCTFail("Invalid URL error is expected")
                   case .invalidURL:
                       promise.fulfill()
                    }
            } else {
                XCTFail("Invalid URL error is expected")
            }
        }
        networkingService.performRequest(route: networkingRoute, session: session, completion: completionBlock)
        wait(for: [promise], timeout: 1)
        
    }

}
