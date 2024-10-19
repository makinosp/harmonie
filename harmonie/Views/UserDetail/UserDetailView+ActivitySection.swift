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
            DividedVStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading) {
                    Text("Last Login")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text(user.lastLogin.formatted(date: .numeric, time: .shortened))
                        .font(.callout)
                }
                VStack(alignment: .leading) {
                    Text("Last Activity")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text(user.lastActivity.formatted(date: .numeric, time: .shortened))
                        .font(.callout)
                }
                if let dateJoined = user.dateJoined {
                    VStack(alignment: .leading) {
                        Text("Date Joined")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text(dateJoined.formatted(date: .numeric, time: .shortened))
                            .font(.callout)
                    }
                }
            }
        }
        .groupBoxStyle(.card)
    }
}
