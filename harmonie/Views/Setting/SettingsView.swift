//
//  SettingsView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/10.
//

import AsyncSwiftUI
import LicenseList
import VRCKit

struct SettingsView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State var sheetType: SheetType?
    let thumbnailSize = CGSize(width: 40, height: 40)

    enum SheetType: Identifiable {
        case userDetail, license
        var id: Int { hashValue }
    }

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
            .navigationTitle("Settings")
        }
        .sheet(item: $sheetType) { sheetType in
            presentSheet(sheetType)
        }
    }

    @ViewBuilder
    func presentSheet(_ sheetType: SheetType) -> some View {
        switch sheetType {
        case .userDetail:
            if let user = appVM.user {
                UserDetailView(id: user.id)
                    .presentationDetents([.medium, .large])
                    .presentationBackground(Color(UIColor.systemGroupedBackground))
            }
        case .license:
            licenseView
                .presentationDetents([.large])
                .presentationBackground(Color(UIColor.systemGroupedBackground))
        }
    }

    var settingsContent: some View {
        List {
            if let user = appVM.user {
                Section(header: Text("My Profile")) {
                    Button {
                        sheetType = .userDetail
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
                .textCase(nil)
            }
            Section(header: Text("Open Source License Notice")) {
                Link(destination: URL(string: "https://github.com/makinosp/harmonie")!) {
                    Label {
                        Text("Source Code")
                    } icon: {
                        Image(systemName: "curlybraces.square.fill")
                    }
                }
                Button {
                    sheetType = .license
                } label: {
                    Label {
                        Text("Third Party Licence")
                    } icon: {
                        Image(systemName: "info.circle.fill")
                    }
                }
            }
            .textCase(nil)
            Section {
                AsyncButton {
                    await appVM.logout()
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

    var licenseView: some View {
        NavigationView {
            LicenseListView()
                .navigationTitle("LICENSE")
        }
    }

    var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }

    var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
