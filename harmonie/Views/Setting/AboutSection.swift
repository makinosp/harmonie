//
//  AboutSection.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/24.
//

import SwiftUI

extension SettingsView {
    struct AboutSection: View {
        var body: some View {
            Section("About This App") {
                NavigationLabel {
                    Label {
                        Text("About This App")
                    } icon: {
                        Image(systemName: "info.circle")
                    }
                }
                .tag(SettingsDestination.about)
                if let url = URL(string: "https://github.com/makinosp/harmonie") {
                    ExternalLink(
                        title: String(localized: "Source Code"),
                        url: url,
                        systemImage: IconSet.code.systemName
                    )
                }
                NavigationLabel {
                    Label {
                        Text("Third Party Licence")
                    } icon: {
                        Image(systemName: "lightbulb")
                    }
                }
                .tag(SettingsDestination.license)
            }
        }
    }
}
