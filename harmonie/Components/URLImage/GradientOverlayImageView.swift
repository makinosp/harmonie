//
//  GradientOverlayImageView.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/28.
//

import MemberwiseInit
import NukeUI
import SwiftUI

@MemberwiseInit
struct GradientOverlayImageView<T, B>: View where T: View, B: View {
    @Init(.internal) private let imageUrl: URL?
    @Init(.internal, default: nil) private let thumbnailImageUrl: URL?
    @Init(.internal) private let size: CGSize
    @Init(.internal, default: Gradient(colors: [.black.opacity(0.5), .clear])) private let gradient: Gradient
    @Init(.internal, default: { EmptyView() }, escaping: true) private let topContent: () -> T
    @Init(.internal, default: { EmptyView() }, escaping: true) private let bottomContent: () -> B

    var body: some View {
        URLImage(
            imageUrl: imageUrl,
            thumbnailImageUrl: thumbnailImageUrl,
            size: size
        )
        .overlay {
            overlaidGradient(.top, T.self != EmptyView.self)
        }
        .overlay {
            overlaidGradient(.bottom, B.self != EmptyView.self)
        }
        .overlay(alignment: .top) {
            overlaidContent(topContent)
        }
        .overlay(alignment: .bottom) {
            overlaidContent(bottomContent)
        }
    }

    @ViewBuilder
    private func overlaidGradient(_ startPoint: UnitPoint, _ isVisible: Bool) -> some View {
        if isVisible {
            LinearGradient(
                gradient: gradient,
                startPoint: startPoint,
                endPoint: .center
            )
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func overlaidContent<Content: View>(_ content: (() -> Content)?) -> some View {
        if let content = content {
            content()
        } else {
            EmptyView()
        }
    }
}
