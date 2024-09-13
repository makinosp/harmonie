//
//  Untitled.swift
//  Harmonie
//
//  Created by xili on 2024/09/13.
//

import SwiftUI
import VRCKit

extension WorldDetailView {
    func descriptionSection(_ description: String) -> some View {
        SectionView {
            Text("Description")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            Text(description)
                .font(.body)
        }
    }
}
