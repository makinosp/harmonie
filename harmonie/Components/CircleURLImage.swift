//
//  CircleURLImage.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/06.
//

import NukeUI
import SwiftUI

struct CircleURLImage: View {
    let imageUrl: URL?
    let size: CGSize

    var body: some View {
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
                ProgressView()
                    .controlSize(.small)
                    .frame(size: size)
            }
        }
    }
}
