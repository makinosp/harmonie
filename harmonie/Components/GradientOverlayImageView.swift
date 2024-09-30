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
    private let height: CGFloat
    private let maxWidth: CGFloat
    private let gradient = Gradient(colors: [.black.opacity(0.5), .clear])
    private let topContent: () -> TopContent
    private let bottomContent: () -> BottomContent

    init(
        imageUrl: URL?,
        thumbnailImageUrl: URL? = nil,
        height: CGFloat,
        maxWidth: CGFloat? = nil,
        @ViewBuilder topContent: @escaping () -> TopContent = { EmptyView() },
        @ViewBuilder bottomContent: @escaping () -> BottomContent = { EmptyView() }
    ) {
        self.imageUrl = imageUrl
        self.thumbnailImageUrl = thumbnailImageUrl
        self.height = height
        self.topContent = topContent
        self.bottomContent = bottomContent
        self.maxWidth = maxWidth ?? WindowUtil.width
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
