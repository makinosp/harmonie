//
//  SettingsView+AboutSection.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/24.
//

import SwiftUI

extension SettingsView {
    var aboutSection: some View {
        Section("About This App") {
            NavigationLabel {
                Label {
                    Text("About This App")
                } icon: {
                    Image(systemName: "info.circle")
                }
            }
            .tag(Destination.about)
            if let sourceCodeUrl = URL(string: "https://github.com/makinosp/harmonie") {
                Link(destination: sourceCodeUrl) {
                    LabeledContent {
                        IconSet.linkExternal.icon
                            .imageScale(.small)
                            .foregroundStyle(Color(.tertiaryLabel))
                    } label: {
                        Label("Source Code", systemImage: IconSet.code.systemName)
                    }
                }
            }
            NavigationLabel {
                Label {
                    Text("Third Party Licence")
                } icon: {
                    Image(systemName: "lightbulb")
                }
            }
            .tag(Destination.license)
        }
    }

    var aboutThisApp: some View {
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
