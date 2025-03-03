//
//  ExitButton.swift
//  Harmonie
//
//  Created by makinosp on 2025/01/22.
//

import SwiftUI

struct ExitButton: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(white: colorScheme == .dark ? 0.19 : 0.93))
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .font(Font.body.weight(.bold))
                .scaleEffect(0.416)
                .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
        }
        .frame(width: 24, height: 24)
    }
}
