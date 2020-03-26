//
//  EventsRouteMock.swift
//  SeatGeekEventsTests
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

struct NoClientInfoRouteMock: NetworkRouter {
    let method: HTTPMethod = .get
    let urlString: String = "https://www.google.com"
    let path: String = ""
    var parameters: [String : String?] = [:]
}

struct InvalidURLRouteMock: NetworkRouter {
    
    let method: HTTPMethod = .get
    let urlString: String = "$%#___+?"
    let path: String = ""
    var parameters: [String : String?] = [:]
}
