//
//  EventsListViewModel.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 24.03.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

protocol EventsListViewModelProtocol {
    
    var isNoEventsFound: Observable<Bool> { get }
    var searchString: Observable<String?> { get }
    var selectedIndexPath: Observable<IndexPath?> { get }
    var nextEventToDisplay: Observable<EventViewModelProtocol?> { get }
    var events: MutableObservableArray<EventViewModelProtocol> { get }
    var error: Observable<Error?> { get }
    
    func loadNewPage()
}

final class EventsListViewModel: EventsListViewModelProtocol {
    let isNoEventsFound: Observable<Bool> = Observable<Bool>(false)
    let searchString: Observable<String?> = Observable<String?>("")
    let selectedIndexPath: Observable<IndexPath?> = Observable<IndexPath?>(nil)
    let nextEventToDisplay: Observable<EventViewModelProtocol?> = Observable<EventViewModelProtocol?>(nil)
    let events: MutableObservableArray<EventViewModelProtocol> = MutableObservableArray([])
    let error: Observable<Error?> = Observable<Error?>(nil)
    
    private var currentPage = 1
    private var isNewPageLoading = false
    
    private let disposeBag = DisposeBag()
    private let eventsFilter: DuplicatesFilter
    
    init(eventsFilter: DuplicatesFilter = EventsDuplicatesFilter()) {
        self.eventsFilter = eventsFilter
        let searchStringDisposable = searchString
            .debounce(for: 0.5)
            .removeDuplicates()
            .observeNext { [unowned self] text in
                self.loadEvents(with: text ?? "")
        }
        
        let indexPathDisposable = selectedIndexPath.observeNext(with: { [unowned self] indexPath in
            guard let indexPath = indexPath else { return }
            let nextEvent = self.events[indexPath.row]
            self.nextEventToDisplay.value = nextEvent
        })
        
        [searchStringDisposable, indexPathDisposable].forEach({ $0.dispose(in: disposeBag) })

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

        EventsClient().loadData(searchString: searchString, page: page) { [weak self] (eventsResponse, error) in
            
            guard let self = self else { return }
            if let error = error {
                self.error.value = error
                return
            }
            guard var events = eventsResponse?.events, events.count > 0 else {
                self.isNoEventsFound.value = true
                self.events.removeAll()
                self.isNewPageLoading = false
                self.currentPage = page
                return
            }
            self.isNoEventsFound.value = false
            if page < 2 {
                self.eventsFilter.resetElementsIdentifiers()
            }
            
            events = self.eventsFilter.filterDuplicates(from: events) as! [Event]
            self.currentPage = page
            let eventsViewModels = events.map({ EventTableViewCellViewModel(event: $0)})
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
