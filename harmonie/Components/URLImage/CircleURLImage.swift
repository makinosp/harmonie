//
//  CircleURLImage.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/06.
//

import MemberwiseInit
import SwiftUI

@MemberwiseInit
struct CircleURLImage: View {
    @Init(.internal) private let imageUrl: URL?
    @Init(.internal, default: nil) private let thumbnailImageUrl: URL?
    @Init(.internal) private let size: CGSize

    var body: some View {
        URLImage(
            imageUrl: imageUrl,
            thumbnailImageUrl: thumbnailImageUrl,
            shape: Circle(),
            size: size
        )
    }
}
