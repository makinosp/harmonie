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
    var locationDescription: String {
        if let instance = instance {
            instance.world.name
        } else if !user.isVisible {
            user.location.capitalized
        } else if isRequesting {
            String(repeating: " ", count: 15)
        } else {
            ""
        }
    }

    var locationSection: some View {
        SectionView {
            Text("Location")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            HStack {
                SquareURLImage(url: instance?.world.imageUrl(.x256))
                Text(locationDescription)
                    .font(.body)
            }
            .redacted(reason: isRequesting ? .placeholder : [])
        }
    }
}
