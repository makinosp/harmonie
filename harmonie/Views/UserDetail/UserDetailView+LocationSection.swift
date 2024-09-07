//
//  UserDetailView+LocationSection.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/06.
//

import NukeUI
import SwiftUI
import VRCKit

extension UserDetailView {
    var locationDescription: String? {
        if let instance = instance {
            instance.world.name
        } else if user.location == "private" || user.location == "offline" {
            user.location.capitalized
        } else {
            nil
        }
    }

    var locationSection: some View {
        SectionView {
            Text("Location")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            HStack {
                if let instance = instance {
                    SquareURLImage(url: instance.world.imageUrl(.x256))
                }
                if let location = locationDescription {
                    Text(location)
                        .font(.body)
                }
            }
        }
    }
}
