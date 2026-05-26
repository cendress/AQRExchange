//
//  ExchangeRateService.swift
//  AQRExchange
//
//  Created by Christopher Endress on 5/26/26.
//

import Foundation

enum ExchangeRateServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The exchange rate URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .serverError(let statusCode):
            return "The server returned an error with status code \(statusCode)."
        case .decodingFailed:
            return "Failed to decode exchange rate data."
        }
    }
}

final class ExchangeRateService: ExchangeRateProviding {
    private let baseURL = URL(string: "https://api.dolarapp.dev/v1/tickers")!
    
    func fetchExchangeRates(for currencies: [String]) async throws -> [ExchangeRate] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "currencies", value: currencies.joined(separator: ","))
        ]
        
        guard let url = components?.url else {
            throw ExchangeRateServiceError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ExchangeRateServiceError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw ExchangeRateServiceError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode([ExchangeRate].self, from: data)
        } catch {
            throw ExchangeRateServiceError.decodingFailed
        }
    }
}
