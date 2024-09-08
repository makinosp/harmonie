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
        } else if user.location == .offline {
            "Offline"
        } else if user.location == .private {
            "Private World"
        } else if isRequesting {
            String(repeating: " ", count: 15)
        } else {
            ""
        }
    }

    var locationImageUrl: URL? {
        if user.isVisible {
            return instance?.imageUrl(.x256)
        }
        return switch user.location {
        case .offline:
            Const.offlineImageUrl
        case .private, .traveling:
            Const.privateWorldImageUrl
        default:
            nil
        }
    }

    var locationSection: some View {
        SectionView {
            Text("Location")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            HStack {
                SquareURLImage(url: locationImageUrl)
                Text(locationDescription)
                    .font(.body)
            }
            .redacted(reason: isRequesting ? .placeholder : [])
        }
    }
}
