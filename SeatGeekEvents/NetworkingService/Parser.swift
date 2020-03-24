//
//  Parser.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

protocol EventsParser {
    func parseItems(from data: Data) -> EventsResponse?
}

struct EventsJSONParser: EventsParser {
    func parseItems(from data: Data) -> EventsResponse? {
        return try? JSONDecoder().decode(EventsResponse.self, from: data)
    }
    
}
