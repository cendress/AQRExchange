//
//  CurrencyInputFieldView.swift
//  AQRExchange
//
//  Created by Christopher Endress on 5/27/26.
//

import SwiftUI

struct CurrencyInputFieldView: View {
    let flag: String
    let currencyCode: String
    let amount: String
    let isSelectable: Bool
    let onAmountChange: (String) -> Void
    let onCurrencyTap: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                if isSelectable {
                    onCurrencyTap()
                }
            }) {
                HStack(spacing: 8) {
                    Text(flag)
                        .font(.title3)
                    
                    Text(currencyCode)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.82))
                    
                    if isSelectable {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.black.opacity(0.75))
                    }
                }
            }
            
            Spacer()
            
            TextField("0", text: Binding(
                get: {
                    amount
                },
                set: { newValue in
                    onAmountChange(Self.sanitizedDecimalInput(newValue))
                }
            ))
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.black.opacity(0.82))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 23)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private static func sanitizedDecimalInput(_ value: String) -> String {
        let allowedCharacters = "0123456789."
        var filtered = value.filter { allowedCharacters.contains($0) }
        
        var hasSeenDecimal = false
        
        filtered = filtered.filter { character in
            if character == "." {
                if hasSeenDecimal {
                    return false
                } else {
                    hasSeenDecimal = true
                    return true
                }
            }
            
            return true
        }
        
        return String(filtered)
    }
}

#Preview("USDc Field") {
    ZStack {
        Color("MainBackground")
            .ignoresSafeArea()
        
        CurrencyInputFieldView(
            flag: "🇺🇸",
            currencyCode: "USDc",
            amount: "9999",
            isSelectable: false,
            onAmountChange: { _ in },
            onCurrencyTap: {}
        )
        .padding()
    }
}

#Preview("Selectable Currency Field") {
    ZStack {
        Color("MainBackground")
            .ignoresSafeArea()
        
        CurrencyInputFieldView(
            flag: "🇲🇽",
            currencyCode: "MXN",
            amount: "184065.59",
            isSelectable: true,
            onAmountChange: { _ in },
            onCurrencyTap: {}
        )
        .padding()
    }
}
