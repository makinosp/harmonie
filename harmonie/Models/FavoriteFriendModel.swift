//
//  FavoriteFriendModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/16.
//

import VRCKit

struct FavoriteFriend: Hashable {
    let favoriteGroupId: String
    var friends: [Friend]
}
