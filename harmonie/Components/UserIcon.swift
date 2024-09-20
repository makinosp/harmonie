//
//  UserIcon.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/20.
//

import SwiftUI
import VRCKit

struct UserIcon: View {
    private let user: any ProfileElementRepresentable
    private let size: CGSize

    init(user: any ProfileElementRepresentable, size: CGSize) {
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
