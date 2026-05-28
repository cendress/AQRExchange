# ARQExchange

ARQExchange is a native iOS currency exchange calculator built in SwiftUI.

The app allows users to convert between USDc and supported currencies using live exchange rate data from the provided API. It includes two-way input, currency selection, visual currency swapping, loading/error handling, and a fallback strategy for the unavailable currencies endpoint.

## Features

- Convert between USDc and supported currencies
- Enter an amount in either field and automatically update the other field
- Select a non-USDc currency from a bottom sheet
- Swap the visual order of the currency fields
- Fetch live exchange rate data from the provided ticker API
- Gracefully handle loading and error states
- Use a local fallback currency list while the currencies API is unavailable
- UI closely follows the provided Figma reference using native SwiftUI components

## Tech Stack

- Swift
- SwiftUI
- Async/await
- URLSession
- MVVM
- Asset Catalog colors and images

## Architecture

The project uses a lightweight MVVM structure.

```text
ARQExchange
├── Models
│   └── ExchangeRate.swift
├── Services
│   ├── ExchangeRateProviding.swift
│   ├── ExchangeRateService.swift
│   ├── CurrencyProviding.swift
│   └── CurrencyService.swift
├── ViewModels
│   └── ExchangeCalculatorViewModel.swift
└── Views
    ├── ExchangeCalculatorView.swift
    ├── CurrencyInputFieldView.swift
    ├── CurrencySelectionSheet.swift
    └── FlagIconView.swift
```

### Models

`ExchangeRate` represents the exchange rate response returned by the API. The API provides `ask`, `bid`, `book`, and `date` values. Since `ask` and `bid` are returned as strings, the model exposes decimal convenience properties for conversion calculations.

### Services

`ExchangeRateService` is responsible for fetching exchange rate data from the provided ticker endpoint.

`CurrencyService` is responsible for loading available currencies. Since the provided available currencies endpoint is not currently implemented, the service attempts to fetch from the expected endpoint and falls back to a local list.

### ViewModel

`ExchangeCalculatorViewModel` owns the main screen state, including:

- selected currency
- available currencies
- USDc amount
- selected currency amount
- loading state
- error state
- exchange rate lookup
- input direction
- swap state

It also contains the conversion logic and ensures that the two text fields do not fight each other when one field updates the other.

### Views

The SwiftUI views are intentionally kept focused on presentation. User actions are passed back to the ViewModel, which handles state updates and business logic.

## Conversion Logic

The app supports conversion in both directions.

```text
USDc → selected currency:
USDc amount × exchange rate

selected currency → USDc:
selected currency amount ÷ exchange rate
```

The ViewModel tracks which field the user is actively editing so the app can update the opposite field without creating a state update loop.

## Design Notes

The UI follows the provided Figma reference as closely as possible while using native SwiftUI controls.

Implemented design details include:

- off white app background
- white rounded currency input cards
- green accent color
- circular clipped flag images
- bottom-sheet currency selector
- native iOS decimal keyboard
- system font

## Error Handling

The app includes basic handling for:

- invalid URLs
- invalid server responses
- non-2xx status codes
- JSON decoding failures
- unavailable currencies endpoint
- empty or invalid user input
- missing exchange rate data

## Running the App

1. Clone the repository.
2. Open `ARQExchange.xcodeproj` in Xcode.
3. Select an iOS simulator.
4. Build and run the app.

No additional setup is required.

## Tradeoffs

A few decisions were made to keep the app focused and reliable within the expected 10–15 hour scope:

- The app uses a lightweight MVVM structure instead of introducing heavier architecture.
- The unavailable currencies endpoint is handled with a local fallback.
- The fallback currency list is limited to currencies with working exchange rate data.
- The app uses the system font.
- Conversion uses `Decimal` rather than `Double` to better suit currency related calculations.

## Future Improvements

Given more time, I would consider adding:

- Unit tests for conversion behavior
- More detailed handling of bid/ask behavior
- Better offline messaging
- Currency search in the bottom sheet
- More robust currency formatting by locale
- Retry support for failed network requests
