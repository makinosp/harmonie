//
//  GradientOverlayImageView.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/28.
//

import NukeUI
import SwiftUI

struct GradientOverlayImageView<TopContent, BottomContent>: View where TopContent: View, BottomContent: View {
    let url: URL?
    let maxHeight: CGFloat
    let gradient = Gradient(colors: [.black.opacity(0.5), .clear])
    let topContent: () -> TopContent
    let bottomContent: () -> BottomContent

    init(
        url: URL?,
        maxHeight: CGFloat,
        @ViewBuilder topContent: @escaping () -> TopContent = { EmptyView() },
        @ViewBuilder bottomContent: @escaping () -> BottomContent
    ) {
        self.url = url
        self.maxHeight = maxHeight
        self.topContent = topContent
        self.bottomContent = bottomContent
    }

    var body: some View {
        lazyImage
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

    @MainActor var lazyImage: some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: maxHeight)
                    .clipped()
            } else if state.error != nil {
                Constants.Icon.exclamation
                    .frame(height: maxHeight)
            } else {
                ZStack {
                    Color.clear
                    ProgressView()
                }
                .frame(height: maxHeight)
            }
        }
    }

    @ViewBuilder
    func overlaidGradient(_ startPoint: UnitPoint, _ isVisible: Bool) -> some View {
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
    func overlaidContent<Content: View>(_ content: (() -> Content)?) -> some View {
        if let content = content {
            content()
        } else {
            EmptyView()
        }
    }
}
