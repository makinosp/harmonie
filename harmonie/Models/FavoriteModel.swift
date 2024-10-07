//
//  FavoriteModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/16.
//

import VRCKit

struct FavoriteFriend: Sendable, Hashable {
    let favoriteGroupId: String
    let friends: [Friend]
}

extension FavoriteFriend: Identifiable {
    var id: String { favoriteGroupId }
}

struct FavoriteWorldGroup: Sendable, Hashable {
    let group: FavoriteGroup?
    let worlds: [FavoriteWorld]
}

extension FavoriteWorldGroup: Identifiable {
    var id: Int { hashValue }
}
