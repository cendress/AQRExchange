//
//  ExchangeRate.swift
//  AQRExchange
//
//  Created by Christopher Endress on 5/26/26.
//

import SwiftUI

struct ExchangeRate: Codable {
    let ask: String
    let bid: String
    let book: String
    let date: String
    
    var askDecimal: Decimal? {
        Decimal(string: ask)
    }
    
    var bidDecimal: Decimal? {
        Decimal(string: bid)
    }
    
    var currency: String? {
        book
            .split(separator: "_")
            .last
            .map { String($0).uppercased() }
    }
}
