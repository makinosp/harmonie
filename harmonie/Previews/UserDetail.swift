//
//  UserDetail.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/21.
//

import Foundation
import VRCKit

extension PreviewDataProvider {
    static func previewUserDetail(id: UUID, instance: Instance) -> UserDetail {
        UserDetail(
            id: id,
            location: .id(instance.id),
            state: .active,
            status: .active,
            isFriend: false
        )
    }

    static func userDetail(
        id: UUID,
        location: Location,
        state: User.State,
        status: UserStatus,
        isFriend: Bool = true
    ) -> UserDetail {
        UserDetail(id: id, location: location, state: state, status: status, isFriend: isFriend)
    }
}

private extension UserDetail {
    init(
        id: UUID = UUID(),
        bio: String = "Demo",
        displayName: String = PreviewString.name.randomValue,
        location: Location,
        state: User.State,
        status: UserStatus,
        statusDescription: String = "Demo",
        isFriend: Bool = true,
        dateJoined: Date = Date(),
        lastActivity: Date = Date()
    ) {
        self.init(
            bio: bio,
            bioLinks: SafeDecodingArray(),
            avatarImageUrl: PreviewDataProvider.iconImageUrl,
            avatarThumbnailUrl: PreviewDataProvider.iconImageUrl,
            displayName: displayName,
            id: "usr_\(id.uuidString)",
            isFriend: isFriend,
            lastLogin: Date(),
            lastPlatform: "standalonewindows",
            profilePicOverride: PreviewDataProvider.iconImageUrl,
            state: state,
            status: status,
            statusDescription: statusDescription,
            tags: UserTags(),
            userIcon: PreviewDataProvider.iconImageUrl,
            location: location,
            friendKey: "",
            dateJoined: dateJoined,
            note: "",
            lastActivity: lastActivity,
            platform: .blank
        )
    }
}
