//
//  FriendsViewPreview.swift
//  friendplus
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

#Preview("FriendsView") {
    FriendsView(
        onlineFriends: [
            Friend(
                bio: "bio",
                bioLinks: ["https://twitter.com/makinovrc"],
                currentAvatarImageUrl: "https://api.vrchat.cloud/api/1/file/file_29cc0315-390e-44b1-b9f1-6eb7601ca5fd/2/file",
                currentAvatarThumbnailImageUrl: "https://api.vrchat.cloud/api/1/image/file_29cc0315-390e-44b1-b9f1-6eb7601ca5fd/2/512",
                developerType: "string",
                displayName: "displayName",
                id: UUID().uuidString,
                isFriend: true,
                lastLogin: Date(),
                lastPlatform: "lastPlatform",
                status: "active",
                statusDescription: "statusDescription",
                tags: ["tag"]
            )
        ]
    )
    .environmentObject(UserData())
}
