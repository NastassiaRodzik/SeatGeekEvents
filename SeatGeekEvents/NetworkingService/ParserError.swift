//
//  ParserError.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 21.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

enum ParserError: Error {
    case cannotDecodeData
}

extension ParserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cannotDecodeData:
            return NSLocalizedString("Cannot convert data. Data is in the wrong format", comment: "")
        }
    }
}
