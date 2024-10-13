//
//  CircleURLImage.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/06.
//

import MemberwiseInit
import NukeUI
import SwiftUI

@MemberwiseInit
struct CircleURLImage: View {
    @Init(.internal) private let imageUrl: URL?
    @Init(.internal, default: nil) private let thumbnailImageUrl: URL?
    @Init(.internal) private let size: CGSize

    var body: some View {
        lazyImage(url: imageUrl) {
            lazyImage(url: thumbnailImageUrl) {
                defaultPlaceholder
            }
        }
    }

    private var defaultPlaceholder: some View {
        shape
            .fill(color)
            .frame(size: size)
    }

    private var shape: some Shape {
        Circle()
    }

    private var color: some ShapeStyle {
        Color(.systemFill)
    }

    private func lazyImage(url: URL?, placeholder: @escaping () -> some View) -> some View {
        LazyImage(url: imageUrl) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(size: size)
                    .clipShape(shape)
            } else if state.error != nil {
                defaultPlaceholder
                    .overlay(IconSet.exclamation.icon)
                    .frame(size: size)
            } else {
                placeholder()
            }
        }
    }
}
