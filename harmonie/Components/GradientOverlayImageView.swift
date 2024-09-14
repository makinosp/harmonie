//
//  GradientOverlayImageView.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/28.
//

import NukeUI
import SwiftUI

struct GradientOverlayImageView<TopContent, BottomContent>: View where TopContent: View, BottomContent: View {
    private let imageUrl: URL?
    private let thumbnailImageUrl: URL?
    private let maxHeight: CGFloat
    private let gradient = Gradient(colors: [.black.opacity(0.5), .clear])
    private let topContent: () -> TopContent
    private let bottomContent: () -> BottomContent

    init(
        imageUrl: URL?,
        thumbnailImageUrl: URL? = nil,
        maxHeight: CGFloat,
        @ViewBuilder topContent: @escaping () -> TopContent = { EmptyView() },
        @ViewBuilder bottomContent: @escaping () -> BottomContent
    ) {
        self.imageUrl = imageUrl
        self.thumbnailImageUrl = thumbnailImageUrl
        self.maxHeight = maxHeight
        self.topContent = topContent
        self.bottomContent = bottomContent
    }

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
                    .frame(maxHeight: maxHeight)
                    .clipped()
            } else if state.error != nil {
                Constants.Icon.exclamation
            } else {
                placeholder()
            }
        }
        .frame(height: maxHeight)
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
