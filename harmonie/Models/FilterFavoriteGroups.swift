//
//  FilterFavoriteGroups.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/19.
//

import VRCKit

enum FilterFavoriteGroups: Hashable {
    case all, favoriteGroup(FavoriteGroup)
}

extension FilterFavoriteGroups: Identifiable {
    var id: Int { hashValue }
}
