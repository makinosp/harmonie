//
//  SettingsView+AboutSection.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/24.
//

import SwiftUI

extension SettingsView {
    var aboutSection: some View {
        Section("About") {
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
                    Label {
                        Text("Source Code")
                    } icon: {
                        Image(systemName: "curlybraces")
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
                Text("App Version")
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}
