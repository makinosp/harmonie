//
//  FriendsLocation.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/27.
//

import VRCKit

extension PreviewData {
    static var friendsLocation: FriendsLocation {
        FriendsLocation(
            location: .offline,
            friends: (0...5).map { _ in friend }
        )
    }
}
