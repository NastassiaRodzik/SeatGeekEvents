//
//  Event.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 24.03.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

struct EventsResponse: Codable {
    let events: [Event]
}

struct Event: Codable {
    let identifier: Int
    let title: String?
    let shortTitle: String?
    let venue: Venue?
    let dateTime: String?
    let timeIsNotDetermined: Bool? 
    let performers: [Performer]?
    
}

extension Event {
    private enum CodingKeys : String, CodingKey {
        case identifier = "id"
        case title
        case shortTitle = "short_title"
        case venue
        case dateTime = "datetime_local"
        case timeIsNotDetermined = "time_tbd"
        case performers
    }
}


struct Venue: Codable {
    let location: String?
}

extension Venue {
    private enum CodingKeys : String, CodingKey {
        case location = "display_location"
    }
}

struct Performer: Codable {
    let imageURL: String?
    let isPrimary: Bool?
}

extension Performer {
    private enum CodingKeys : String, CodingKey {
        case imageURL = "image"
        case isPrimary = "primary"
    }
}
