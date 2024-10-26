//
//  ExternalLink.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/26.
//

import MemberwiseInit
import SwiftUI

@MemberwiseInit
struct ExternalLink {
    @State private var isPresentedAlert = false
    @Init(.internal) private let title: String
    @Init(.internal) private let url: URL
    @Init(.internal) private let systemImage: String
}

extension ExternalLink: View {
    var body: some View {
        Button {
            isPresentedAlert.toggle()
        } label: {
            LabeledContent {
                IconSet.linkExternal.icon
                    .imageScale(.small)
                    .foregroundStyle(Color(.tertiaryLabel))
            } label: {
                Label(title, systemImage: systemImage)
                    .lineLimit(1)
            }
        }
        .alert("Opening URL", isPresented: $isPresentedAlert) {
            Button("Cancel", role: .cancel) {}
            Link("OK", destination: url)
        } message: {
            Text(verbatim: url.absoluteString)
        }
    }
}
