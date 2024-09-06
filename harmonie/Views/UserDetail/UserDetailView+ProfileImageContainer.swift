//
//  UserDetailView+ProfileImageContainer.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/06.
//

import SwiftUI
import VRCKit

extension UserDetailView {
    var statusColor: Color {
        user.state == .offline ? UserStatus.offline.color : user.status.color
    }

    func profileImageContainer(url: URL) -> some View {
        GradientOverlayImageView(
            url: url,
            maxHeight: 250,
            bottomContent: { bottomBar }
        )
    }

    var bottomBar: some View {
        HStack {
            HStack(alignment: .bottom) {
                Label {
                    Text(user.displayName)
                } icon: {
                    Constants.Icon.circleFilled
                        .foregroundStyle(statusColor)
                }
                .font(.headline)
                statusDescription
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }

    var statusDescription: some View {
        Text(user.statusDescription)
            .lineLimit(1)
            .font(.subheadline)
    }

    var displayStatusAndName: some View {
        HStack(alignment: .bottom) {
            Label {
                Text(user.displayName)
            } icon: {
                Constants.Icon.circleFilled
                    .foregroundStyle(user.status.color)
            }
            .font(.headline)
            Text(user.statusDescription)
                .font(.subheadline)
            Spacer()
        }
        .padding(8)
    }
}
