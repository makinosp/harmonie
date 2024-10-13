//
//  ShowMoreText.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/12.
//

import MemberwiseInit
import SwiftUI

@MemberwiseInit
struct ShowMoreText: View {
    @State private var isExpanded = false
    @Init(.internal, label: "_") private let text: String
    @Init(.internal, default: 3) private let lineLimit: Int

    var body: some View {
        VStack(spacing: 3) {
            Text(text)
                .lineLimit(isExpanded ? nil : lineLimit)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                withAnimation { isExpanded.toggle() }
            } label: {
                Text(isExpanded ? "Show less" : "Show more")
                    .fontWeight(.regular)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
