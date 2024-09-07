//
//  SquareURLImage.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/07.
//

import NukeUI
import SwiftUI

struct SquareURLImage: View {
    @State private var isImageLoaded = false
    private let url: URL?
    private let frameWidth: CGFloat
    private let cornerRadius: CGFloat

    init(url: URL?, frameWidth: CGFloat = 100, cornerRadius: CGFloat = 4) {
        self.url = url
        self.frameWidth = frameWidth
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            } else if state.error != nil {
                Constants.Icon.exclamation
            } else {
                EmptyView()
                    .onDisappear {
                        isImageLoaded = true
                    }
            }
        }
        .frame(width: frameWidth, height: frameWidth * 3/4)
        .redacted(reason: isImageLoaded ? .placeholder : [])
    }
}
