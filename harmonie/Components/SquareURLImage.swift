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
    private let imageUrl: URL?
    private let thumbnailImageUrl: URL?
    private let frameWidth: CGFloat
    private let cornerRadius: CGFloat
    private let ratio: CGFloat

    init(
        imageUrl: URL?,
        thumbnailImageUrl: URL? = nil,
        frameWidth: CGFloat = 100,
        ratio: CGFloat = 3/4,
        cornerRadius: CGFloat = 4
    ) {
        self.imageUrl = imageUrl
        self.thumbnailImageUrl = thumbnailImageUrl
        self.frameWidth = frameWidth
        self.cornerRadius = cornerRadius
        self.ratio = ratio
    }

    var rect: some Shape {
        RoundedRectangle(cornerRadius: cornerRadius)
    }

    var body: some View {
        lazyImage(url: imageUrl) {
            lazyImage(url: thumbnailImageUrl) {
                rect.fill(Color(.systemFill))
            }
        }
    }

    func lazyImage(url: URL?, placeholder: @escaping () -> some View) -> some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
            } else if url != nil && state.error != nil {
                Constants.IconSet.exclamation.icon
            } else {
                placeholder()
            }
        }
        .onCompletion { _ in
            isImageLoaded = true
        }
        .animation(.default, value: isImageLoaded)
        .frame(width: frameWidth, height: frameWidth * ratio)
        .clipShape(rect)
    }
}
