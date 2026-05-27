//
//  ExchangeCalculatorView.swift
//  AQRExchange
//
//  Created by Christopher Endress on 5/27/26.
//

import SwiftUI

struct ExchangeCalculatorView: View {
    @StateObject private var viewModel = ExchangeCalculatorViewModel()
    @State private var isCurrencySheetPresented = false

    var body: some View {
        ZStack {
            Color("MainBackground")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Exchange calculator")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.black.opacity(0.84))
                        .padding(.bottom, 8)
                    
                    Text(viewModel.rateDisplayText)
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundStyle(Color("Brand"))
                        .padding(.bottom, 30)
                }

                currencyFieldsStack

//                if viewModel.isLoading {
//                    ProgressView()
//                        .frame(maxWidth: .infinity, alignment: .center)
//                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.red.opacity(0.85))
                }

                Spacer()
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .task {
            await viewModel.loadInitialData()
        }
        .sheet(isPresented: $isCurrencySheetPresented) {
            CurrencySelectionSheet(
                currencies: viewModel.availableCurrencies,
                selectedCurrency: viewModel.selectedCurrency,
                flagImageProvider: viewModel.flagImageName(for:),
                onSelect: { currency in
                    viewModel.selectCurrency(currency)
                    isCurrencySheetPresented = false
                },
                onDismiss: {
                    isCurrencySheetPresented = false
                }
            )
            .presentationDetents([.height(428)])
            .presentationDragIndicator(.hidden)
        }
    }

    private var currencyFieldsStack: some View {
        ZStack {
            VStack(spacing: 16) {
                if viewModel.isUSDcOnTop {
                    usdcField
                    foreignField
                } else {
                    foreignField
                    usdcField
                }
            }

            Button(action: {
                viewModel.swapCurrencies()
            }) {
                ZStack {
                    Circle()
                        .fill(Color("Brand"))
                        .frame(width: 26, height: 26)

                    Image(systemName: viewModel.isUSDcOnTop ? "arrow.down" : "arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                }
                .padding(6)
                .background(Color("MainBackground"))
                .clipShape(.circle)
            }
        }
    }

    private var usdcField: some View {
        CurrencyInputFieldView(
            flagImageName: viewModel.usdcFlag,
            currencyCode: "USDc",
            amount: viewModel.usdcAmount,
            isSelectable: false,
            onAmountChange: { value in
                viewModel.updateUSDCAmount(value)
            },
            onCurrencyTap: {}
        )
    }

    private var foreignField: some View {
        CurrencyInputFieldView(
            flagImageName: viewModel.selectedCurrencyFlag,
            currencyCode: viewModel.selectedCurrency,
            amount: viewModel.foreignAmount,
            isSelectable: true,
            onAmountChange: { value in
                viewModel.updateForeignAmount(value)
            },
            onCurrencyTap: {
                isCurrencySheetPresented = true
            }
        )
    }
}

#Preview("Exchange Calculator") {
    ExchangeCalculatorView()
}
