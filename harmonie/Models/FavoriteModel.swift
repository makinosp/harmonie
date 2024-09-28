//
//  FavoriteModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/16.
//

import VRCKit

struct FavoriteFriend: Sendable, Hashable {
    let favoriteGroupId: String
    var friends: [Friend]
}

struct FavoriteWorldGroup: Sendable, Hashable {
    let group: FavoriteGroup?
    var worlds: [FavoriteWorld]
}

extension FavoriteWorldGroup: Identifiable {
    var id: Int { hashValue }
}
