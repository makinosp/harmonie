//
//  SettingsView+AboutSection.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/24.
//

import SwiftUI

extension SettingsView {
    private var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }

    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    var aboutSection: some View {
        Section("About") {
            LabeledContent {
                Constants.Icon.forward
            } label: {
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
            LabeledContent {
                Constants.Icon.forward
            } label: {
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
                Text(appName)
            } label: {
                Text("App Name")
            }
            LabeledContent {
                Text(appVersion)
            } label: {
                Text("App Version")
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}
