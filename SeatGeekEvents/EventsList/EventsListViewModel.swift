//
//  EventsListViewModel.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 24.03.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation
import Bond

protocol EventsListViewModelProtocol {
    
    var searchString: Observable<String?> { get set }
    var events: MutableObservableArray<EventTableViewCellViewModelProtocol> { get }
    func loadEvents(with searchString: String)
}

class EventsListViewModel: EventsListViewModelProtocol {
    var searchString: Observable<String?> = Observable<String?>("")
    var events: MutableObservableArray<EventTableViewCellViewModelProtocol> = MutableObservableArray([])
    
    init() {
        _ = searchString
            .debounce(for: 0.5)
            .observeNext {
            [unowned self] text in
            guard let text = text else {
              return
            }
            self.loadEvents(with: text)
        }
    }
    
    func loadEvents(with searchString: String) {
        guard searchString.count > 0 else {
            self.events.removeAll()
            return
        }
        print("loading events with \(searchString)")
        EventsClient().loadData(searchString: searchString) { [weak self] (data, error) in
            guard let self = self else { return }
            if let data = data {
                if let events = EventsJSONParser().parseItems(from: data) {
                    print("----")
                    for event in events.events {
                        let eventImageURL = event.performers?
                            .filter({ $0.isPrimary != nil && $0.isPrimary! })
                            .first?
                            .imageURL
                        
                        print("event id \(event.identifier) imgURL \(eventImageURL ?? "")")
                        
                    }
                    print("----")
                    let eventsViewModels = events.events.map({ EventTableViewCellViewModel(event: $0)})
                    self.events.removeAll()
                    self.events.insert(contentsOf: eventsViewModels, at: 0)
                }
            }
        }
    }
}
