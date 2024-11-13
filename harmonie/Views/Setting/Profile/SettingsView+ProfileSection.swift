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
            .tag(SettingsDestination.userDetail)
            .padding(8)

            Button("Edit", systemImage: IconSet.edit.systemName) {
                isPresentedForm.toggle()
            }
        }
        .textCase(nil)
    }
}
