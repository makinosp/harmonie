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
        } else if user.location == .private {
            "Private World"
        } else if user.location == .offline {
            "Offline"
        } else if isRequesting {
            String(repeating: " ", count: 15)
        } else {
            ""
        }
    }

    private var locationImageUrl: URL? {
        switch user.location {
        case .id:
            user.platform == .web ? Const.locationOnWebImageUrl : instance?.imageUrl(.x256)
        case .private, .traveling:
            Const.privateWorldImageUrl
        case .offline:
            Const.offlineImageUrl
        }
    }

    var locationSection: some View {
        GroupBox("Location") {
            HStack {
                SquareURLImage(imageUrl: locationImageUrl)
                Text(locationDescription)
                    .font(.headline)
            }
            .redacted(reason: isRequesting ? .placeholder : [])
        }
        .groupBoxStyle(.card)
    }
}
