//
//  Favorite.swift
//  Harmonie
//
//  Created by makinosp on 2024/11/04.
//

import Foundation
import VRCKit

extension PreviewData {
    static let favoriteGroups = FavoriteType.allCases.flatMap { type in
        (1...3).map { number in
            FavoriteGroup(
                id: "fvgrp_\(UUID().uuidString)",
                displayName: "\(type.rawValue.capitalized) Group \(number)",
                name: "group_\(number)",
                ownerId: PreviewData.shared.previewUser.id,
                tags: [],
                type: type,
                visibility: .private
            )
        }
    }
}
