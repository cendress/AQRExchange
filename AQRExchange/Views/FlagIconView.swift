//
//  FlagIconView.swift
//  AQRExchange
//
//  Created by Christopher Endress on 5/27/26.
//

import SwiftUI

struct FlagIconView: View {
    let imageName: String
    var size: CGFloat = 28

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(.circle)
    }
}

#Preview("Flag Icon") {
    HStack(spacing: 16) {
        FlagIconView(imageName: "flag_us", size: 28)
        FlagIconView(imageName: "flag_mx", size: 28)
        FlagIconView(imageName: "flag_ar", size: 28)
    }
    .padding()
    .background(Color("MainBackground"))
}
