//
//  ExchangeCalculatorViewModel.swift
//  AQRExchange
//
//  Created by Christopher Endress on 5/26/26.
//

import Combine
import SwiftUI

enum ActiveInput {
    case usdc
    case foreign
}

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
    
    private var activeInput: ActiveInput?
    
    private let exchangeRateProvider: ExchangeRateProviding
    private let currencyProvider: CurrencyProviding
    
    private var selectedExchangeRate: ExchangeRate? {
        exchangeRatesByCurrency[selectedCurrency]
    }
    
    init(
        exchangeRateProvider: ExchangeRateProviding? = nil,
        currencyProvider: CurrencyProviding? = nil
    ) {
        self.exchangeRateProvider = exchangeRateProvider ?? ExchangeRateService()
        self.currencyProvider = currencyProvider ?? CurrencyService()
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
            })
            
            recalculateCurrentInput()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    //MARK: - Update values
    
    func updateUSDCAmount(_ value: String) {
        activeInput = .usdc
        usdcAmount = value
        foreignAmount = convertForeignToUSDC(value)
    }
    
    func updateForeignAmount(_ value: String) {
        activeInput = .foreign
        foreignAmount = value
        usdcAmount = convertForeignToUSDC(value)
    }
    
    private func convertUSDCToForeign(_ value: String) -> String {
        guard let usdcDecimal = Decimal(string: value),
              let rate = selectedExchangeRate?.askDecimal else {
            return ""
        }

        let convertedAmount = usdcDecimal * rate
        return format(convertedAmount)
    }

    private func convertForeignToUSDC(_ value: String) -> String {
        guard let foreignDecimal = Decimal(string: value),
              let rate = selectedExchangeRate?.askDecimal,
              rate != 0 else {
            return ""
        }

        let convertedAmount = foreignDecimal / rate
        return format(convertedAmount)
    }
    
    func selectCurrency(_ currency: String) {
        selectedCurrency = currency
        recalculateCurrentInput()
    }
    
    private func recalculateCurrentInput() {
        switch activeInput {
        case .usdc:
            foreignAmount = convertUSDCToForeign(usdcAmount)
        case .foreign:
            usdcAmount = convertForeignToUSDC(foreignAmount)
        case .none:
            break
        }
    }
    
    func swapCurrencies() {
        isUSDcOnTop.toggle()
    }
    
    //MARK: - Helpers
    
    // Converts decimals to strings to display in usdc/foreign fields
    private func format(_ value: Decimal) -> String {
        let number = NSDecimalNumber(decimal: value)

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.maximumFractionDigits = 4
        formatter.minimumFractionDigits = 0

        return formatter.string(from: number) ?? ""
    }
    
    var selectedCurrencyFlag: String {
        flag(for: selectedCurrency)
    }

    var usdcFlag: String {
        "🇺🇸"
    }

    var rateDisplayText: String {
        guard let rate = selectedExchangeRate?.askDecimal else {
            return "Loading exchange rate..."
        }

        return "1 USDc = \(format(rate)) \(selectedCurrency)"
    }

    func flag(for currency: String) -> String {
        switch currency {
        case "USDc":
            return "🇺🇸"
        case "MXN":
            return "🇲🇽"
        case "ARS":
            return "🇦🇷"
        case "BRL":
            return "🇧🇷"
        case "COP":
            return "🇨🇴"
        case "EURc":
            return "🇪🇺"
        default:
            return "🌐"
        }
    }
}
