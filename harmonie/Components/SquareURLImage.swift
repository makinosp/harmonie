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
    @Init(.internal, default: 3/4) private let cornerRadius: CGFloat
    @Init(.internal, default: 4) private let ratio: CGFloat

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
                IconSet.exclamation.icon
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
