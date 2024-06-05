//
//  SectionModifier.swift
//  harmonie
//
//  Created by makinosp on 2024/06/05.
//

import SwiftUI

struct SectionModifier: ViewModifier {
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
