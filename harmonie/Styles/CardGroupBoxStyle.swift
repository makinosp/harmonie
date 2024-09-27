//
//  CardGroupBoxStyle.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/27.
//

import SwiftUI

struct CardGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            configuration.content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color(.secondarySystemGroupedBackground))
        }
        .padding(.horizontal, 8)
    }
}

extension GroupBoxStyle where Self == CardGroupBoxStyle {
    static var card: CardGroupBoxStyle {
        CardGroupBoxStyle()
    }
}
