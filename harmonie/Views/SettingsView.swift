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
    @State var isSheetOpened = false
    let thumbnailSize = CGSize(width: 40, height: 40)

    var body: some View {
        NavigationStack {
            VStack {
                settingsContent
                HStack {
                    Text(appName)
                    Text(appVersion)
                }
                .font(.footnote)
            }
            .padding()
            .navigationTitle("Settings")
        }
        .sheet(isPresented: $isSheetOpened) {
            if let user = userData.user {
                UserDetailView(id: user.id)
                    .presentationDetents([.medium, .large])
                    .presentationBackground(Color(UIColor.systemGroupedBackground))
            }
        }
    }

    var settingsContent: some View {
        List {
            if let user = userData.user {
                Section(header: Text("My Profile")) {
                    Button {
                        isSheetOpened.toggle()
                    } label: {
                        HStack {
                            CircleURLImage(
                                imageUrl: user.userIconUrl,
                                size: thumbnailSize
                            )
                            Text(user.displayName)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
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

    var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }

    var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
