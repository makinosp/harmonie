//
//  HACircleImage.swift
//  harmonie
//
//  Created by makinosp on 2024/06/06.
//

import NukeUI
import SwiftUI

struct HACircleImage: View {
    let imageUrl: String
    let size: CGSize

    var body: some View {
        LazyImage(url: URL(string: imageUrl)) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(size: size)
                    .clipShape(Circle())
            } else if state.error != nil {
                Image(systemName: "exclamationmark.circle")
                    .frame(size: size)
            } else {
                ProgressView()
                    .controlSize(.small)
                    .frame(size: size)
            }
        }
    }
}
