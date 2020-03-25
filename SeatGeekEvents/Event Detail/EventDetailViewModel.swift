//
//  EventDetailViewModel.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/24/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

protocol EventViewModel {
    
    var eventViewModel: EventTableViewCellViewModelProtocol { get }
    
}

struct EventDetailViewModel: EventViewModel {
    var eventViewModel: EventTableViewCellViewModelProtocol
    
    init(eventViewModel: EventTableViewCellViewModelProtocol) {
        self.eventViewModel = eventViewModel
    }
}

