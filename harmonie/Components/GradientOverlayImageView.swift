//
//  GradientOverlayImageView.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/28.
//

import SwiftUI
import NukeUI

struct GradientOverlayImageView<Content>: View where Content: View {
    let url: URL
    let maxHeight: CGFloat
    let gradient = Gradient(colors: [.black.opacity(0.5), .clear])
    let topContent: (() -> Content)?
    let bottomContent: (() -> Content)?

    init(
        url: URL,
        maxHeight: CGFloat,
        topContent: (() -> Content)? = nil,
        bottomContent: (() -> Content)? = nil
    ) {
        self.url = url
        self.maxHeight = maxHeight
        self.topContent = topContent
        self.bottomContent = bottomContent
    }

    var body: some View {
        lazyImage
            .overlay {
                overlaidGradient(.top, topContent != nil)
            }
            .overlay {
                overlaidGradient(.bottom, bottomContent != nil)
            }
            .overlay(alignment: .top) {
                overlaidContent(topContent)
            }
            .overlay(alignment: .bottom) {
                overlaidContent(bottomContent)
            }
    }

    @MainActor
    var lazyImage: some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else if state.error != nil {
                Image(systemName: Constants.IconName.exclamation)
            } else {
                ZStack {
                    Color.clear
                    ProgressView()
                }
            }
        }
        .frame(maxHeight: maxHeight)
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
    func overlaidContent(_ content: (() -> Content)?) -> some View {
        if let content = content {
            content()
        } else {
            EmptyView()
        }
    }
}
