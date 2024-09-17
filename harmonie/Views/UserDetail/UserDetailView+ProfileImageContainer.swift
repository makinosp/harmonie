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
    var statusIsWebColor: Color {
        user.state == .offline ? UserStatus.offline.color : user.platform.isWebColor
    }

    var topOverlay: some View {
        HStack {
            Spacer()
            Label {
                Text(DateUtil.shared.formatRelative(from: user.lastActivity))
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

    var bottomBar: some View {
        VStack(alignment: .leading) {
            Text(user.displayName)
                .font(.headline)
            HStack {
                statusDescription
                Spacer()
                trustRankLabel
            }
        }
        .foregroundStyle(Color.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }

    var statusDescription: some View {
        Label {
            Text(user.statusDescription.isEmpty ? user.status.description : user.statusDescription)
        } icon: {
            ZStack {
                Constants.Icon.circleFilled
                    .foregroundStyle(statusColor)
                Constants.Icon.circleSmallFilled
                    .foregroundStyle(statusIsWebColor)
            }
        }
        .lineLimit(1)
        .font(.subheadline)
    }

    var trustRankLabel: some View {
        Label {
            Text(user.trustRank.description)
        } icon: {
            Constants.Icon.shield
        }
        .font(.footnote.bold())
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(trustRankColor(user.trustRank).opacity(0.5))
        .background(.thinMaterial)
        .cornerRadius(8)
    }

    func trustRankColor(_ trustRank: TrustRank) -> Color {
        switch trustRank {
        case .trusted: .indigo
        case .known: .orange
        case .user: .green
        case .newUser: .blue
        case .visitor, .unknown: .gray
        }
    }
}
