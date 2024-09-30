//
//  UserDetailView+OverlayViews.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/06.
//

import SwiftUI
import VRCKit

extension UserDetailView {
    var topOverlay: some View {
        HStack {
            Spacer()
            Label {
                Text(lastActivity)
            } icon: {
                Image(systemName: "stopwatch")
            }
            .font(.footnote.bold())
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(.regularMaterial)
            .cornerRadius(8)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }

    var bottomOverlay: some View {
        HStack {
            status
            Spacer()
            trustRankLabel
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }

    private var statusDescription: String {
        if user.state == .offline {
            UserStatus.offline.description
        } else {
            user.statusDescription.isEmpty ? user.status.description : user.statusDescription
        }
    }

    var status: some View {
        Label {
            Text(statusDescription)
        } icon: {
            StatusIndicator(
                user.state != .offline ? user.status.color : UserStatus.offline.color,
                size: Constants.IconSize.indicator,
                isCutOut: user.platform == .web
            )
        }
        .lineLimit(1)
        .font(.subheadline)
    }

    var trustRankLabel: some View {
        Label {
            Text(user.trustRank.description)
        } icon: {
            Constants.IconSet.shield.icon
        }
        .font(.footnote.bold())
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(user.trustRank.color.opacity(0.5))
        .background(.thinMaterial)
        .cornerRadius(8)
    }
}
