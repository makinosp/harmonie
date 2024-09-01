//
//  SettingsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/10.
//

import AsyncSwiftUI
import LicenseList
import VRCKit

struct SettingsView: View {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @State var destination: Destination?
    @State var isPresentedForm = false

    enum Destination: Hashable {
        case userDetail, about, license
    }

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            settingsContent
                .navigationDestination(item: $destination) { destination in
                    presentDestination(destination)
                }
                .navigationTitle("Settings")
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            if UIDevice.current.userInterfaceIdiom == .pad {
                destination = .userDetail
            }
        }
        .sheet(isPresented: $isPresentedForm) {
            if let user = appVM.user {
                ProfileEditView(profileEditVM: ProfileEditViewModel(user: user))
            }
        }
    }

    @ViewBuilder
    func presentDestination(_ destination: Destination) -> some View {
        switch destination {
        case .userDetail:
            if let user = appVM.user {
                UserDetailPresentationView(id: user.id)
            }
        case .about:
            aboutThisApp
        case .license:
            LicenseListView()
                .navigationTitle("Third Party Licence")
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    var settingsContent: some View {
        List {
            if let user = appVM.user {
                profileSection(user: user)
            }
            aboutSection
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
}
