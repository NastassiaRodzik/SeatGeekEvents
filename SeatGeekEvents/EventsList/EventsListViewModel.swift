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
    
    var searchString: Observable<String?> { get }
    var selectedIndexPath: Observable<IndexPath?> { get }
    var nextEventToDisplay: Observable<EventViewModelProtocol?> { get }
    var events: MutableObservableArray<EventViewModelProtocol> { get }
    
    func loadNewPage()
}

final class EventsListViewModel: EventsListViewModelProtocol {
    let searchString: Observable<String?> = Observable<String?>(nil)
    let selectedIndexPath: Observable<IndexPath?> = Observable<IndexPath?>(nil)
    let nextEventToDisplay: Observable<EventViewModelProtocol?> = Observable<EventViewModelProtocol?>(nil)
    let events: MutableObservableArray<EventViewModelProtocol> = MutableObservableArray([])
    
    var currentPage = 1
    var isNewPageLoading = false
    
    init() {
        _ = searchString
            .debounce(for: 0.5)
            .observeNext { [unowned self] text in
            guard let text = text else { return }
            self.loadEvents(with: text)
        }
        
        _ = selectedIndexPath.observeNext(with: { [unowned self] indexPath in
            guard let indexPath = indexPath else { return }
            let nextEvent = self.events[indexPath.row]
            self.nextEventToDisplay.value = nextEvent
        })

    }
    
    func loadNewPage() {
        if isNewPageLoading {
            return
        }
        guard let query = searchString.value else {
            return
        }
        isNewPageLoading = true
        loadEvents(with: query, page: currentPage + 1)
    }
    
    private func loadEvents(with searchString: String, page: Int = 1) {
        guard searchString.count > 0 else {
            self.events.removeAll()
            return
        }
        print("loading events with \(searchString) page \(page)")
        EventsClient().loadData(searchString: searchString, page: page) { [weak self] (data, error) in
            guard let self = self else { return }
            if let data = data {
                if let events = EventsJSONParser().parseItems(from: data) {
                    self.currentPage = page
                    let eventsViewModels = events.events.map({ EventTableViewCellViewModel(event: $0)})
                    
                    if page == 1 {
                        self.events.removeAll()
                        self.events.insert(contentsOf: eventsViewModels, at: 0)
                    } else {
                        let lastIndex = self.events.count - 1 > 0 ? self.events.count - 1 : 0
                        self.events.insert(contentsOf: eventsViewModels, at: lastIndex)
                    }
                    self.isNewPageLoading = false
                }
            }
        }
    }

}
