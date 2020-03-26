//
//  EventsRoute.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/24/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

private enum Server {
    enum Production {
        static let baseURL = "https://api.seatgeek.com/2/"
    }
    
    enum PathComponent {
        static let events = "events"
    }
    
    enum Parameter {
        static let clientId = "client_id"
        static let searchString = "q"
        static let page = "page"
    }
    
    enum SeatGeekConstants {
        static let clientId = "MjExNDE1MjN8MTU4NTAwNTQ2My44OA"
    }
}


struct EventsRoute: NetworkRouter {
    
    let method: HTTPMethod = .get
    let urlString: String = Server.Production.baseURL
    let path: String = Server.PathComponent.events
    let parametersString: String
    
    init(searchString: String, page: Int) {
        let modifiedSearchString = searchString.replacingOccurrences(of: " ", with: "+")
        parametersString = "?\(Server.Parameter.clientId)=\(Server.SeatGeekConstants.clientId)&\(Server.Parameter.searchString)=\(modifiedSearchString)&\(Server.Parameter.page)=\(page)"
    }

}
