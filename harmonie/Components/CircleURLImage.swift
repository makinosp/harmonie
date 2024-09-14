//
//  CircleURLImage.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/06.
//

import NukeUI
import SwiftUI

struct CircleURLImage: View {
    private let imageUrl: URL?
    private let thumbnailImageUrl: URL?
    private let size: CGSize

    init(imageUrl: URL?, thumbnailImageUrl: URL? = nil, size: CGSize) {
        self.imageUrl = imageUrl
        self.thumbnailImageUrl = thumbnailImageUrl
        self.size = size
    }

    var body: some View {
        lazyImage(url: imageUrl) {
            lazyImage(url: thumbnailImageUrl) {
                ProgressView()
                    .controlSize(.small)
                    .frame(size: size)
            }
        }
    }

    func lazyImage(url: URL?, placeholder: @escaping () -> some View) -> some View {
        LazyImage(url: imageUrl) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(size: size)
                    .clipShape(Circle())
            } else if state.error != nil {
                Constants.Icon.exclamation
                    .frame(size: size)
            } else {
                placeholder()
            }
        }
    }
}
