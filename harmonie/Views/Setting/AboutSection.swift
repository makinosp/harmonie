//
//  AboutSection.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/24.
//

import SwiftUI

extension SettingsView {
    struct AboutSection: View {
        @State private var isPresentedAlert = false
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
                if let sourceCodeUrl = URL(string: "https://github.com/makinosp/harmonie") {
                    Button {
                        isPresentedAlert.toggle()
                    } label: {
                        LabeledContent {
                            IconSet.linkExternal.icon
                                .imageScale(.small)
                                .foregroundStyle(Color(.tertiaryLabel))
                        } label: {
                            Label("Source Code", systemImage: IconSet.code.systemName)
                        }
                    }
                    .alert("Opening URL", isPresented: $isPresentedAlert) {
                        Button("Cancel", role: .cancel) {}
                        Link("OK", destination: sourceCodeUrl)
                    } message: {
                        VStack {
                            Text("The URL below will be opened")
                            Text(sourceCodeUrl.absoluteString)
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
                .tag(SettingsDestination.license)
            }
        }
    }
}
