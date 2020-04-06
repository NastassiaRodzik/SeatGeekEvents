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
    
    var visibleIndexPaths: (() -> [IndexPath])? { get set }
    
    func loadNewPage()
}

final class EventsListViewModel: EventsListViewModelProtocol {
    let isNoEventsFound: Observable<Bool> = Observable<Bool>(false)
    let searchString: Observable<String?> = Observable<String?>("")
    let selectedIndexPath: Observable<IndexPath?> = Observable<IndexPath?>(nil)
    let nextEventToDisplay: Observable<EventViewModelProtocol?> = Observable<EventViewModelProtocol?>(nil)
    let events: MutableObservableArray<EventViewModelProtocol> = MutableObservableArray([])
    let error: Observable<Error?> = Observable<Error?>(nil)
    
    var visibleIndexPaths: (() -> [IndexPath])?
    
    private var currentPage = 1
    private var isNewPageLoading = false
    
    private let disposeBag = DisposeBag()
    private let eventsFilter: DuplicatesFilter
    private let connectivityManager: ConnectivityManager
    private var lastFailedRequest: (query: String, page: Int)? = nil
    
    init(eventsFilter: DuplicatesFilter = EventsDuplicatesFilter(), connectivityManager: ConnectivityManager = ReachabilityManager()) {
        self.eventsFilter = eventsFilter
        self.connectivityManager = connectivityManager
        
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
        
        let connectivityDisposable = connectivityManager.isConnected
            .dropFirst(1)
            .removeDuplicates()
            .observeNext { [weak self] isConnected in
                guard let self = self else { return }
                if isConnected {
                    if let lastRequest = self.lastFailedRequest {
                        self.loadEvents(with: lastRequest.query, page: lastRequest.page)
                    }
                    self.reloadVisibleImages()
                } else  {
                    // TODO: stop loading if loading and show error?
                }
        }
        [connectivityDisposable, searchStringDisposable, indexPathDisposable].forEach({ $0.dispose(in: disposeBag) })

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
        let isConnectedToInternet = connectivityManager.isConnected.value
        guard isConnectedToInternet else {
            error.value = NetworkError.noInternetConnection
            lastFailedRequest = (searchString, page)
            if page == 1 {
                self.events.removeAll()
            }
            return
        }
        EventsClient().loadData(searchString: searchString, page: page) { [weak self] (eventsResponse, error) in
            
            guard let self = self else { return }
            if let error = error {
                self.error.value = error
                self.isNewPageLoading = false
                // TODO: do we need to update page in this case? what if it is > 1 ?
                self.currentPage = page
                if page == 1 {
                    self.events.removeAll()
                }
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
    
    private func reloadVisibleImages() {
        guard let visibleIndexPaths = self.visibleIndexPaths?(), visibleIndexPaths.count > 0 else { return }
        let visibleRows = visibleIndexPaths.map({ $0.row })
        let events = self.events.value.collection
        if let first = visibleRows.first, let last = visibleRows.last, last > first {
            let visibleEvents = events[first...last]
            for event in visibleEvents {
                event.reloadImageIfNeeded()
            }
        }
    }

}
