//
//  UserDetailView+BioSection.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/06.
//

import SwiftUI
import VRCKit

extension UserDetailView {
    func bioSection(_ bio: String) -> some View {
        GroupBox("Bio") {
            Text(bio)
                .font(.body)
        }
        .groupBoxStyle(.card)
    }
}
