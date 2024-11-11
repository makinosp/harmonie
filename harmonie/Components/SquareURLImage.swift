//
//  SquareURLImage.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/07.
//

import NukeUI
import MemberwiseInit
import SwiftUI

@MemberwiseInit
struct SquareURLImage: View {
    @State private var isImageLoaded = false
    @Init(.internal) private let imageUrl: URL?
    @Init(.internal, default: nil) private let thumbnailImageUrl: URL?
    @Init(.internal, default: 100) private let frameWidth: CGFloat
    @Init(.internal, default: 4) private let cornerRadius: CGFloat
    @Init(.internal, default: 3/4) private let ratio: CGFloat

    var shape: some Shape {
        RoundedRectangle(cornerRadius: cornerRadius)
    }

    var body: some View {
        lazyImage(url: imageUrl) {
            lazyImage(url: thumbnailImageUrl) {
                shape.fill(color)
            }
        }
    }

    private var defaultPlaceholder: some View {
        shape
            .fill(color)
            .frame(size: size)
    }

    private var size: CGSize {
        CGSize(width: frameWidth, height: frameWidth * ratio)
    }

    private var color: some ShapeStyle {
        Color(.systemFill)
    }

    func lazyImage(url: URL?, placeholder: @escaping () -> some View) -> some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
            } else if url != nil && state.error != nil {
                IconSet.photo.icon
            } else {
                placeholder()
            }
        }
        .onCompletion { _ in
            isImageLoaded = true
        }
        .animation(.default, value: isImageLoaded)
        .frame(size: size)
        .clipShape(shape)
    }
}
