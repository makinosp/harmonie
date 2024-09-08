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
        VStack(alignment: .leading) {
            Text(user.displayName)
                .font(.headline)
            HStack {
                statusDescription
                Spacer()
                trustRankLabel
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }

    var statusDescription: some View {
        Label {
            Text(user.statusDescription.isEmpty ?  user.status.description : user.statusDescription)
        } icon: {
            Constants.Icon.circleFilled
                .foregroundStyle(statusColor)
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
