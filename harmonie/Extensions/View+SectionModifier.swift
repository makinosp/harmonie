//
//  View+SectionModifier.swift
//  harmonie
//
//  Created by makinosp on 2024/06/05.
//

import SwiftUI

extension View {
    func sectioning() -> some View {
        modifier(SectionModifier())
    }
}

private struct SectionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color(UIColor.secondarySystemGroupedBackground))
            }
    }
}
