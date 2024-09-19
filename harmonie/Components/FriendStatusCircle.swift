//
//  FriendStatusCircle.swift
//  Harmonie
//
//  Created by xili on 2024/09/19.
//

import SwiftUI

struct FriendStatusCircle: View {
    private let statusColor: Color
    private let platformColor: Color
    init(statusColor: Color, platformColor: Color) {
        self.statusColor = statusColor
        self.platformColor = platformColor
    }
    var body: some View {
        Circle()
            .frame(
                width: Constants.IconSize.thumbnailOutside.width * 0.3,
                height: Constants.IconSize.thumbnailOutside.height * 0.3
            )
            .foregroundColor(statusColor)
            .overlay(
                Circle()
                    .frame(
                        width: Constants.IconSize.thumbnailOutside.width * 0.15,
                        height: Constants.IconSize.thumbnailOutside.height * 0.15
                    )
                    .foregroundColor(platformColor)
            )
            .offset(
                x: Constants.IconSize.thumbnailOutside.width * 0.36,
                y: Constants.IconSize.thumbnailOutside.height * 0.36
            )
    }
}
