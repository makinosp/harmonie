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

    init(user: any ProfileElementRepresentable) {
        self.user = user
    }

    var body: some View {
        ZStack {
            BittenView {
                CircleURLImage(
                    imageUrl: user.imageUrl(.x256),
                    size: Constants.IconSize.thumbnail
                )
            }
            StatusIndicator(
                user.status.color,
                outerSize: Constants.IconSize.thumbnail,
                isCutOut: user.platform == .web
            )
        }
    }
}
