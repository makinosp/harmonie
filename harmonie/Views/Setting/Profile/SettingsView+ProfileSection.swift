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
            LabeledContent {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    Constants.Icon.forward
                }
            } label: {
                Label {
                    Text(user.displayName)
                } icon: {
                        UserIcon(user: user, size: Constants.IconSize.ll)
                }
                .padding(.vertical, 8)
            }
            .tag(Destination.userDetail)

            Button {
                isPresentedForm = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
        }
        .textCase(nil)
    }
}
