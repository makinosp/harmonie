//
//  WorldDetailView+ProfileImageContainer.swift
//  Harmonie
//
//  Created by xili on 2024/09/13.
//

import SwiftUI
import VRCKit

extension WorldDetailView {
    func profileImageContainer(url: URL) -> some View {
        GradientOverlayImageView(
            url: url,
            maxHeight: 250,
            bottomContent: { bottomBar }
        )
    }

    var bottomBar: some View {
        VStack(alignment: .leading) {
            Text(world.name)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}
