//
//  ExchangeRateProviding.swift
//  AQRExchange
//
//  Created by Christopher Endress on 5/26/26.
//

import Foundation

protocol ExchangeRateProviding {
    func fetchExchangeRates(for currencies: [String]) async throws -> [ExchangeRate]
}
