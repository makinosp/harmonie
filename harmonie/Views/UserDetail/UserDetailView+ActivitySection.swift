//
//  UserDetailView+ActivitySection.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/12.
//

import SwiftUI

extension UserDetailView {
    var activitySection: some View {
        GroupBox("Activity") {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading) {
                    Text("Last Login")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    Text(user.lastLogin.formatted(date: .complete, time: .complete))
                        .font(.body)
                }
                VStack(alignment: .leading) {
                    Text("Last Activity")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    Text(user.lastActivity.formatted(date: .complete, time: .complete))
                        .font(.body)
                }
                if let dateJoined = user.dateJoined {
                    VStack(alignment: .leading) {
                        Text("Date Joined")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                        Text(dateJoined.formatted(date: .abbreviated, time: .omitted))
                            .font(.body)
                    }
                }
            }
        }
        .groupBoxStyle(.card)
    }
}
