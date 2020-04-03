//
//  EventsDuplicatesFilter.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/30/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

class EventsDuplicatesFilter: DuplicatesFilter {
    
    private var existingItemsIdentifiers: Set<Int> = Set<Int>()
    
    func filterDuplicates(from elements: [IntIdentifiable]) -> [IntIdentifiable] {
        var filteredElements = elements
        for (index, element) in elements.enumerated().reversed() {
            if existingItemsIdentifiers.contains(element.identifier) {
                filteredElements.remove(at: index)
            } else {
                existingItemsIdentifiers.insert(element.identifier)
            }
        }
        return filteredElements
    }
    
    func resetElementsIdentifiers() {
        existingItemsIdentifiers.removeAll()
    }
    
}
