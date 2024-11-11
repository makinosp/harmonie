//
//  SquareURLImage.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/07.
//

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

    var body: some View {
        URLImage(
            imageUrl: imageUrl,
            thumbnailImageUrl: thumbnailImageUrl,
            shape: RoundedRectangle(cornerRadius: cornerRadius),
            size: size
        )
    }

    private var size: CGSize {
        CGSize(width: frameWidth, height: frameWidth * ratio)
    }
}
