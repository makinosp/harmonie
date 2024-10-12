//
//  SettingsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/10.
//

import LicenseList
import SwiftUI
import VRCKit

struct SettingsView: View, AuthenticationServiceRepresentable {
    @Environment(AppViewModel.self) var appVM
    @State var destination: Destination? = UIDevice.current.userInterfaceIdiom == .pad ? .userDetail : nil
    @State var isPresentedForm = false
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var selectedLibrary: Library?

    enum Destination: Hashable {
        case userDetail, favoriteGroups, about, license
    }

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
            ProfileEditView(profileEditVM: ProfileEditViewModel(user: appVM.user))
        }
        .sheet(item: $selectedLibrary) { library in
            LicenseView(library: library)
        }
    }

    @ViewBuilder
    private func presentDestination(_ destination: Destination) -> some View {
        switch destination {
        case .userDetail:
            UserDetailPresentationView(id: appVM.user.id)
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
            profileSection(user: appVM.user)
            Section("Favorite") {
                Label("Favorite Groups", systemImage: IconSet.favoriteGroup.systemName)
                    .tag(Destination.favoriteGroups)
            }
            aboutSection
            Section {
                LogoutButton()
            }
        }
    }
}
