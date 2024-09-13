//
//  WorldDetailView+.swift
//  Harmonie
//
//  Created by xili on 2024/09/13.
//

import SwiftUI
import VRCKit

extension WorldDetailView {
    func authorNameSection(_ authorName: String) -> some View {
        SectionView {
            Text("Author")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            Text(authorName)
                .font(.body)
        }
    }
}
