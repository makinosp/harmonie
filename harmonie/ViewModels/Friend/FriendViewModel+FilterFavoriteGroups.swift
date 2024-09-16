//
//  FriendViewModel+FilterFavoriteGroups.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/16.
//

import VRCKit

extension FriendViewModel {
    enum FilterFavoriteGroups: Hashable, Identifiable {
        case all, favoriteGroup(FavoriteGroup)
        var id: Int { hashValue }
    }
}
