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
        Section(header: Text("My Profile")) {
            Button {
                destination = .userDetail
            } label: {
                HStack(alignment: .center) {
                    Label {
                        Text(user.displayName)
                    } icon: {
                        CircleURLImage(
                            imageUrl: user.thumbnailUrl,
                            size: Constants.IconSize.ll
                        )
                    }
                    Spacer()
                    Constants.Icon.forward
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            Button {
                isPresentedForm = true
            } label: {
                HStack(alignment: .center) {
                    Label("Edit", systemImage: "pencil")
                }
            }
        }
        .textCase(nil)
    }
}
