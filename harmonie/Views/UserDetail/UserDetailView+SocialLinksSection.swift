//
//  UserDetailView+SocialLinksSection.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/06.
//

import SwiftUI
import VRCKit

extension UserDetailView {
    func socialLinksSection(_ urls: [URL]) -> some View {
        GroupBox("Social Links") {
            DividedVStack(alignment: .leading) {
                ForEach(urls) { url in socialLink(url) }
            }
        }
        .groupBoxStyle(.card)
    }

    private func socialLink(_ url: URL) -> Link<some View> {
        Link(destination: url) {
            LabeledContent {
                IconSet.linkExternal.icon
                    .imageScale(.small)
                    .foregroundStyle(Color(.tertiaryLabel))
            } label: {
                Label(url.description, systemImage: IconSet.link.systemName)
                    .lineLimit(1)
            }
        }
    }
}
