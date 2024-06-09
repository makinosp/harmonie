//
//  SettingsView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/10.
//

import SwiftUI
import VRCKit

struct SettingsView: View {
    @EnvironmentObject var userData: UserData
    let thumbnailSize = CGSize(width: 40, height: 40)

    var body: some View {
        NavigationSplitView {
            settingsContent.navigationTitle("Settings")
        } detail: { EmptyView() }
    }

    var settingsContent: some View {
        List {
            if let user = userData.user {
                Section(header: Text("My Profile")) {
                    HStack {
                        HACircleImage(
                            imageUrl: (user.userIcon.isEmpty ? user.currentAvatarThumbnailImageUrl : user.userIcon) ?? "",
                            size: thumbnailSize
                        )
                        Text(user.displayName)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())

                    Label {
                        Text("Edit Profile")
                    } icon: {
                        Image(systemName: "square.and.pencil")
                    }
                    Label {
                        Text("Edit Status Descriptions")
                    } icon: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            Section {
                Label {
                    Text("Support")
                } icon: {
                    Image(systemName: "sparkle")
                }
                Label {
                    Text("About")
                } icon: {
                    Image(systemName: "info.circle.fill")
                }
            }
            Section {
                Button {
                    userData.logout()
                } label: {
                    Label {
                        Text("Logout")
                            .foregroundStyle(Color.red)
                    } icon: {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .foregroundStyle(Color.red)
                    }
                }
            }
        }
    }
}
