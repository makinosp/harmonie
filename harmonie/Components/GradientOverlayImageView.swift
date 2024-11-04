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
struct GradientOverlayImageView<TopContent, BottomContent>: View where TopContent: View, BottomContent: View {
    @Init(.internal) private let imageUrl: URL?
    @Init(.internal, default: nil) private let thumbnailImageUrl: URL?
    @Init(.internal) private let height: CGFloat
    @Init(.internal) private let maxWidth: CGFloat
    @Init(.internal, default: Gradient(colors: [.black.opacity(0.5), .clear])) private let gradient: Gradient
    @Init(.internal, default: { EmptyView() }, escaping: true) private let topContent: () -> TopContent
    @Init(.internal, default: { EmptyView() }, escaping: true) private let bottomContent: () -> BottomContent

    var body: some View {
        lazyImage(url: imageUrl) {
            lazyImage(url: thumbnailImageUrl) {
                Color(.systemFill)
            }
        }
        .overlay {
            overlaidGradient(.top, TopContent.self != EmptyView.self)
        }
        .overlay {
            overlaidGradient(.bottom, BottomContent.self != EmptyView.self)
        }
        .overlay(alignment: .top) {
            overlaidContent(topContent)
        }
        .overlay(alignment: .bottom) {
            overlaidContent(bottomContent)
        }
    }

    private func lazyImage(url: URL?, placeholder: @escaping () -> some View) -> some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if state.error != nil {
                IconSet.exclamation.icon
            } else {
                placeholder()
            }
        }
        .frame(height: height)
        .frame(maxWidth: maxWidth)
        .clipped()
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
