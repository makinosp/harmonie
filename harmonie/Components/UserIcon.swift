//
//  UserIcon.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/20.
//

import MemberwiseInit
import SwiftUI
import VRCKit

@MemberwiseInit
struct UserIcon<T>: View where T: ProfileElementRepresentable {
    @Init(.internal) private let user: T
    @Init(.internal) private let size: CGSize

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
