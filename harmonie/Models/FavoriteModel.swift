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

struct FavoriteWorld: Sendable, Hashable {
    let group: FavoriteGroup?
    var worlds: [World]
}

extension FavoriteWorld: Identifiable {
    var id: Int { hashValue }
}
