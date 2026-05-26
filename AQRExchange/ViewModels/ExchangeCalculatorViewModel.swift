//
//  ExchangeCalculatorViewModel.swift
//  AQRExchange
//
//  Created by Christopher Endress on 5/26/26.
//

import Combine
import SwiftUI

@MainActor
final class ExchangeCalculatorViewModel: ObservableObject {
    @Published var availableCurrencies: [String] = []
    @Published var selectedCurrency: String = "MXN"
    
    @Published var usdcAmount: String = ""
    @Published var foreignAmount: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var isUSDcOnTop: Bool = true
    
    private var exchangeRatesByCurrency: [String: ExchangeRate] = [:]
    
    private let exchangeRateProvider: ExchangeRateProviding
    private let currencyProvider: CurrencyProviding
    
    private var selectedExchangeRate: ExchangeRate? {
        exchangeRatesByCurrency[selectedCurrency]
    }
    
    init(
        exchangeRateProvider: ExchangeRateProviding = ExchangeRateService(),
        currencyProvider: CurrencyProviding = CurrencyService()
    ) {
        self.exchangeRateProvider = exchangeRateProvider
        self.currencyProvider = currencyProvider
    }
    
    func loadInitialData() async {
        isLoading = true
        errorMessage = nil
        
        availableCurrencies = await currencyProvider.fetchAvailableCurrencies()
        
        do {
            let exchangeRates = try await exchangeRateProvider.fetchExchangeRates(for: availableCurrencies)
            exchangeRatesByCurrency = Dictionary(uniqueKeysWithValues: exchangeRates.compactMap {
                exchangeRate in
                guard let currencyCode = exchangeRate.currency else {
                    return nil
                }
                
                return (currencyCode, exchangeRate)
            }
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
