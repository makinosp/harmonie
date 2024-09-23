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
    private var locationDescription: String {
        if let instance = instance {
            instance.world.name
        } else if user.platform == .web {
            "On website"
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

    private var locationImageUrl: URL? {
        if user.isVisible {
            return instance?.imageUrl(.x256)
        }
        if user.platform == .web {
            return Const.locationOnWebImageUrl
        } else if user.location == .offline {
            return Const.offlineImageUrl
        } else if user.location == .offline || user.location == .offline || user.location == .offline {
            return Const.privateWorldImageUrl
        } else {
            return nil
        }
    }

    var locationSection: some View {
        SectionView {
            Text("Location")
                .font(.subheadline)
                .foregroundStyle(Color.gray)
            HStack {
                SquareURLImage(imageUrl: locationImageUrl)
                Text(locationDescription)
                    .font(.headline)
            }
            .redacted(reason: isRequesting ? .placeholder : [])
        }
    }
}
