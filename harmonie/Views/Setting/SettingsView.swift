//
//  SettingsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/10.
//

import LicenseList
import SwiftUI
import VRCKit

struct SettingsView: View {
    @Environment(AppViewModel.self) var appVM
    @State var destination: SettingsDestination? = UIDevice.current.userInterfaceIdiom == .pad ? .userDetail : nil
    @State var isPresentedForm = false
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var selectedLibrary: Library?

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            settingsContent
                .navigationTitle("Settings")
        } detail: {
            if let destination = destination {
                presentDestination(destination)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $isPresentedForm) {
            if let user = appVM.user {
                ProfileEditView(user: user)
            }
        }
        .sheet(item: $selectedLibrary) { library in
            LicenseView(library: library)
        }
    }

    @ViewBuilder
    private func presentDestination(_ destination: SettingsDestination) -> some View {
        switch destination {
        case .userDetail:
            if let user = appVM.user {
                UserDetailPresentationView(id: user.id)
            }
        case .favoriteGroups:
            FavoriteGroupsListView()
        case .about:
            aboutThisApp
        case .license:
            List(Library.libraries) { library in
                Button {
                    selectedLibrary = library
                } label: {
                    Text(library.name)
                }
            }
            .navigationTitle("Third Party Licence")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var settingsContent: some View {
        List(selection: $destination) {
            if let user = appVM.user {
                profileSection(user: user)
            }
            Section("Favorite") {
                Label("Favorite Groups", systemImage: IconSet.favoriteGroup.systemName)
                    .tag(SettingsDestination.favoriteGroups)
            }
            AboutSection()
            Section {
                LogoutButton()
            }
        }
    }

    private var aboutThisApp: some View {
        List {
            LabeledContent {
                Text(BundleUtil.appName)
            } label: {
                Text("App Name")
            }
            LabeledContent {
                Text(BundleUtil.appVersion)
            } label: {
                Text("Version")
            }
            LabeledContent {
                Text(BundleUtil.appBuild)
            } label: {
                Text("Build")
            }
        }
        .navigationTitle("About This App")
        .navigationBarTitleDisplayMode(.inline)
    }
}
