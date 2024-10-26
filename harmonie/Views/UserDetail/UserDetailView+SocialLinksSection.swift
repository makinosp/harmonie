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
                ForEach(urls) { url in
                    ExternalLink(title: url.description, url: url, systemImage: IconSet.link.systemName)
                }
            }
        }
        .groupBoxStyle(.card)
    }
}
