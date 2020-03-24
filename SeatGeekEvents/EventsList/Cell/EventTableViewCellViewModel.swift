//
//  EventTableViewCellViewModel.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 24.03.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit
import Bond

protocol EventTableViewCellViewModelProtocol {

    var title: String { get }
    var location: String { get }
    var time: String { get }
    var isFavorite: Bool { get set }
    var image: Observable<UIImage?> { get set }
    
}

class EventTableViewCellViewModel: EventTableViewCellViewModelProtocol {
    
    static var rawEventDateFormatter: DateFormatter {
        let rawStringDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = rawStringDateFormat
        return dateFormatter
    }
    
    static var eventDateFormatter: DateFormatter {
        let datetimeFormat = "EEE, dd MMM yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = datetimeFormat
        return dateFormatter
    }
    
    static var eventDateTimeFormatter: DateFormatter {
        let datetimeFormat = "EEE, dd MMM yyyy h:mm a"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = datetimeFormat
        return dateFormatter
    }
    
    var title: String
    var location: String
    var time: String
    var isFavorite: Bool
    var image: Observable<UIImage?> = Observable<UIImage?>(nil)
    
    init(event: Event) {
        self.title = event.title ?? ""
        self.isFavorite = false
        self.location = event.venue?.location ?? ""
        if let timeRawString = event.dateTime {
            if let eventDate = EventTableViewCellViewModel.rawEventDateFormatter.date(from: timeRawString) {
                if let timeIsNotDetermined = event.timeIsNotDetermined, timeIsNotDetermined {
                    self.time = EventTableViewCellViewModel.eventDateFormatter.string(from: eventDate)
                } else {
                    self.time = EventTableViewCellViewModel.eventDateTimeFormatter.string(from: eventDate)
                }
            } else {
                self.time = ""
            }
        } else {
            self.time = ""
        }
        
        let eventImageURL = event.performers?
                                   .filter({ $0.isPrimary != nil && $0.isPrimary! })
                                   .first?
                                   .imageURL

        if let imageURLString = eventImageURL, let imageURL = URL(string: imageURLString) {
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async { [weak self] in
                        self?.image.value = UIImage(data: data)
                    }
                }
               
            }
            
        }
    }
    
}
