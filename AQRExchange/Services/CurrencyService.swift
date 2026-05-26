//
//  CurrencyService.swift
//  AQRExchange
//
//  Created by Christopher Endress on 5/26/26.
//

import Foundation

final class CurrencyService: CurrencyProviding {
    private let fallbackCurrencies = ["MXN", "ARS", "BRL", "COP"]
    private let currenciesURL = URL(string: "https://api.dolarapp.dev/v1/tickers-currencies")!
    
    func fetchAvailableCurrencies() async -> [String] {
        do {
            let (data, response) = try await URLSession.shared.data(from: currenciesURL)
            
            if let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode {
                return fallbackCurrencies
            }
            
            let currencies = try JSONDecoder().decode([String].self, from: data)
            
            return currencies.isEmpty ? fallbackCurrencies : currencies
        } catch {
            return fallbackCurrencies
        }
    }
}
