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
    @EnvironmentObject var appVM: AppViewModel
    @State var destination: Destination?
    @State var isPresentedForm = false

    enum Destination: Hashable {
        case userDetail, about, license
    }

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            VStack {
                settingsContent
                HStack {
                    Text(appName)
                    Text(appVersion)
                }
                .font(.footnote)
            }
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
                ProfileEditView(user: user)
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
            Text("about!")
        case .license:
            LicenseListView()
        }
    }

    var settingsContent: some View {
        List {
            if let user = appVM.user {
                profileSection(user: user)
            }
            Section("About") {
                LabeledContent {
                    Constants.Icon.forward
                } label: {
                    Button {
                        destination = .about
                    } label: {
                        Label {
                            Text("About This App")
                        } icon: {
                            Image(systemName: "info.circle")
                        }
                    }
                }
                Link(destination: URL(string: "https://github.com/makinosp/harmonie")!) {
                    Label {
                        Text("Source Code")
                    } icon: {
                        Image(systemName: "curlybraces")
                    }
                }
                LabeledContent {
                    Constants.Icon.forward
                } label: {
                    Button {
                        destination = .license
                    } label: {
                        Label {
                            Text("Third Party Licence")
                        } icon: {
                            Image(systemName: "lightbulb")
                        }
                    }
                }
            }
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

    var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }

    var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
