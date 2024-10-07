//
//  UserIcon.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/20.
//

import SwiftUI
import VRCKit

struct UserIcon<T>: View where T: ProfileElementRepresentable {
    private let user: T
    private let size: CGSize

    init(user: T, size: CGSize) {
        self.user = user
        self.size = size
    }

    var body: some View {
        BittenView {
            CircleURLImage(imageUrl: user.imageUrl(.x256), size: size)
        }
        .overlay {
            StatusIndicator(
                user.status.color,
                outerSize: size,
                isCutOut: user.platform == .web
            )
        }
    }
}
