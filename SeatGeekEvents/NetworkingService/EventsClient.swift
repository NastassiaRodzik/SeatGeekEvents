//
//  EventsClient.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/24/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

protocol EventsClientProtocol {
    func loadData(searchString: String, completion: @escaping (Data?, Error?) -> Void)
}

class EventsClient: NetworkClient, EventsClientProtocol {
    func loadData(searchString: String, completion: @escaping (Data?, Error?) -> Void) {
        let route = EventsRoute(searchString: searchString)
        performRequest(route: route, session: URLSession.shared, completion: completion)
    }
}
