//
//  DuplicatesFilter.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/30/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

protocol DuplicatesFilter {
    func filterDuplicates(from elements: [Identifiable]) -> [Identifiable]
    func resetElementsIdentifiers()
}
