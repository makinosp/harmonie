//
//  UserDetailView+BioLinksSection.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/06.
//

import SwiftUI
import VRCKit

extension UserDetailView {
    func bioLinksSection(_ urls: [URL]) -> some View {
        GroupBox("Social Links") {
            VStack(alignment: .leading) {
                ForEach(urls) { url in
                    Link(url.description, destination: url)
                        .font(.body)
                }
            }
        }
        .groupBoxStyle(.card)
    }
}
