//
//  SettingsView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/10.
//

import SwiftUI
import VRCKit

struct SettingsView: View {
    @EnvironmentObject var userData: UserData
    let thumbnailFrame = CGSize(width: 32, height: 32)

    var body: some View {
        if let user = userData.user {
            NavigationSplitView {
                List {
                    Section {
                        HStack {
                            AsyncImage(
                                url: URL(string: user.currentAvatarImageUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(size: thumbnailFrame)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                            Text(user.displayName)
                        }
                    }
                    Section {
//                        Label {
//                            Text("Edit Profile")
//                        } icon: {
//                            Image(systemName: "pencil")
//                        }
//                        Label {
//                            Text(user.statusDescription)
//                        } icon: {
//                            Image(systemName: "ellipsis.bubble")
//                        }
//                        Label {
//                            Text("Edit Status Descriptions")
//                        } icon: {
//                            Image(systemName: "list.bullet")
//                        }
                        Button {
                            userData.logout()
                        } label: {
                            Label {
                                Text("Logout")
                                    .foregroundStyle(Color.red)
                            } icon: {
                                Image(systemName: "delete.forward")
                                    .foregroundStyle(Color.red)
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
                }
                .navigationTitle("Profile")
            } detail: {

            }
        } else {
            EmptyView()
        }
    }
}
