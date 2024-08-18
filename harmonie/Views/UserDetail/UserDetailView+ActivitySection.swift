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
                    Text(DateUtil.shared.formattedDateTime(from: user.lastLogin))
                        .font(.body)
                }
                VStack(alignment: .leading) {
                    Text("Last Activity")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                    Text(DateUtil.shared.formattedDateTime(from: user.lastActivity))
                        .font(.body)
                }
                if let dateJoined = user.dateJoined {
                    VStack(alignment: .leading) {
                        Text("Date Joined")
                            .font(.subheadline)
                            .foregroundStyle(Color.gray)
                        Text(DateUtil.shared.formatToyyyyMMdd(from: dateJoined))
                            .font(.body)
                    }
                }
            }
        }
    }
}
