//
//  CurrencyProviding.swift
//  AQRExchange
//
//  Created by Christopher Endress on 5/26/26.
//

import Foundation

protocol CurrencyProviding {
    func fetchAvailableCurrencies() async -> [String]
}
