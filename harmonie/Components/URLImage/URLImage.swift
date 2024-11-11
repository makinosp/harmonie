//
//  URLImage.swift
//  Harmonie
//
//  Created by makinosp on 2024/11/11.
//

import MemberwiseInit
import NukeUI
import SwiftUI

@MemberwiseInit
struct URLImage<S>: View where S: Shape {
    @State private var isImageLoaded = false
    @Init(.internal) private let imageUrl: URL?
    @Init(.internal, default: nil) private let thumbnailImageUrl: URL?
    @Init(.internal) private let shape: S
    @Init(.internal) private let size: CGSize
    private let color = Color(.systemFill)

    var body: some View {
        lazyImage(url: imageUrl) {
            lazyImage(url: thumbnailImageUrl) {
                emptyPlaceholder
            }
        }
    }

    private func lazyImage(url: URL?, placeholder: @escaping () -> some View) -> some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
            } else if url != nil && state.error != nil {
                placeholder()
                    .overlay(IconSet.photo.icon)
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

    private var emptyPlaceholder: some View {
        shape
            .fill(color)
            .frame(size: size)
    }
}
