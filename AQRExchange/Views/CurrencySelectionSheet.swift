//
//  CurrencySelectionSheet.swift
//  AQRExchange
//
//  Created by Christopher Endress on 5/27/26.
//

import SwiftUI

struct CurrencySelectionSheet: View {
    let currencies: [String]
    let selectedCurrency: String
    let flagImageProvider: (String) -> String
    let onSelect: (String) -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Capsule()
                .fill(Color.gray.opacity(0.25))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 23)

            HStack {
                Text("Choose currency")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.black.opacity(0.84))

                Spacer()

                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.black.opacity(0.82))
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 22)

            VStack {
                ForEach(currencies, id: \.self) { currency in
                    Button(action: {
                        onSelect(currency)
                    }) {
                        HStack(spacing: 8) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color("MainBackground"))
                                    .frame(width: 40, height: 40)

                                FlagIconView(imageName: flagImageProvider(currency), size: 28)
                            }

                            Text(currency)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.78))

                            Spacer()

                            selectionIndicator(isSelected: currency == selectedCurrency)
                        }
                        .padding(.vertical, 11)
                        .padding(.horizontal, 16)
                    }
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.bottom, 16)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("MainBackground"))
    }

    @ViewBuilder
    private func selectionIndicator(isSelected: Bool) -> some View {
        if isSelected {
            ZStack {
                Circle()
                    .fill(Color("Brand"))
                    .frame(width: 24, height: 24)

                Image("CheckmarkIcon")
            }
        } else {
            Circle()
                .stroke(Color.gray.opacity(0.35), lineWidth: 2)
                .frame(width: 24, height: 24)
        }
    }
}

#Preview("Currency Selection Sheet") {
    CurrencySelectionSheet(
        currencies: ["ARS", "EURc", "COP", "MXN", "BRL"],
        selectedCurrency: "MXN",
        flagImageProvider: { currency in
            switch currency {
            case "ARS": return "flag_ar"
            case "EURc": return "flag_eu"
            case "COP": return "flag_co"
            case "MXN": return "flag_mx"
            case "BRL": return "flag_br"
            default: return "flag_us"
            }
        },
        onSelect: { _ in },
        onDismiss: {}
    )
}
