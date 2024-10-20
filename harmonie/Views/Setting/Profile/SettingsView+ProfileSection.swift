//
//  SettingsView+ProfileSection.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/20.
//

import SwiftUI
import VRCKit

extension SettingsView {
    func profileSection(user: User) -> some View {
        Section(header: Text("Profile")) {
            NavigationLabel {
                Label {
                    Text(user.displayName)
                } icon: {
                    UserIcon(user: user, size: Constants.IconSize.ll)
                }
            }
            .tag(Destination.userDetail)
            .padding(8)

            Button {
                isPresentedForm = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
        }
        .textCase(nil)
    }
}
