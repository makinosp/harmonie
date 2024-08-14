//
//  UserDetailView+ActivitySection.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/12.
//

import SwiftUI

extension UserDetailView {
    var activitySection: some View {
        SectionView {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading) {
                    Text("Last Login")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                    Text(lastLoginText)
                        .font(.body)
                }
                VStack(alignment: .leading) {
                    Text("Last Activity")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                    Text(lastActivityText)
                        .font(.body)
                }
            }
        }
    }

    var lastLoginText: String {
        [
            DateUtil.shared.formatToyyyyMMdd(from: user.lastLogin),
            DateUtil.shared.formatToHHmm(from: user.lastLogin)
        ].joined(separator: " ")
    }

    var lastActivityText: String {
        [
            DateUtil.shared.formatToyyyyMMdd(from: user.lastActivity),
            DateUtil.shared.formatToHHmm(from: user.lastActivity)
        ].joined(separator: " ")
    }
}
