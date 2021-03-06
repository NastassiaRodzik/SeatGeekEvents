//
//  EventTableViewCellViewModel.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 24.03.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit
import Bond

protocol EventViewModelProtocol {

    var identifier: Int { get }
    var title: String { get }
    var location: String { get }
    var time: String { get }
    var isFavorite: Observable<Bool> { get }
    var image: Observable<UIImage?> { get }
    
    func reloadImageIfNeeded()
    
}

final class EventTableViewCellViewModel: EventViewModelProtocol {
    
    private static var rawEventDateFormatter: DateFormatter {
        let rawStringDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = rawStringDateFormat
        return dateFormatter
    }
    
    private static var eventDateFormatter: DateFormatter {
        let datetimeFormat = "EEE, dd MMM yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = datetimeFormat
        return dateFormatter
    }
    
    private static var eventDateTimeFormatter: DateFormatter {
        let datetimeFormat = "EEE, dd MMM yyyy h:mm a"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = datetimeFormat
        return dateFormatter
    }
    
    let identifier: Int
    let title: String
    let location: String
    let time: String
    let isFavorite: Observable<Bool>
    let image: Observable<UIImage?> = Observable<UIImage?>(nil)
    
    private var isImageFound = false
    private let imageURL: URL?
    
    init(event: Event, favoritesManager: FavoritesHandler = FavoritesManager()) {
        self.identifier = event.identifier
        self.title = event.title
        self.isFavorite = Observable<Bool>(favoritesManager.isFavorite(eventIdentifier: event.identifier))
        self.location = event.venue?.location ?? ""
        if let timeRawString = event.dateTime,
            let eventDate = EventTableViewCellViewModel.rawEventDateFormatter.date(from: timeRawString) {
            if let timeIsNotDetermined = event.timeIsNotDetermined, timeIsNotDetermined {
                self.time = EventTableViewCellViewModel.eventDateFormatter.string(from: eventDate)
            } else {
                self.time = EventTableViewCellViewModel.eventDateTimeFormatter.string(from: eventDate)
            }
        } else {
            self.time = ""
        }
        
        let eventImageURL = event.performers?
                                   .filter({ $0.isPrimary != nil && $0.isPrimary! })
                                   .first?
                                   .imageURL

        if let imageURLString = eventImageURL, let imageURL = URL(string: imageURLString) {
            self.imageURL = imageURL
        } else {
            isImageFound = true
            imageURL = nil
        }
    }
    
    func loadImage() {
        guard let imageURL = imageURL else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async { [weak self] in
                    self?.image.value = UIImage(data: data)
                    self?.isImageFound = true
                }
            }
           
        }
    }
    
    func reloadImageIfNeeded() {
        if isImageFound { return }
        loadImage()
    }
    
}
