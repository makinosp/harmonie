//
//  UserDetail.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/21.
//

import Foundation
import VRCKit

extension PreviewData {
    static func userDetail(id: UUID, instance: Instance) -> UserDetail {
        UserDetail(id: id, location: .id(instance.id), state: .active, status: .active, isFriend: false)
    }

    static func userDetail(
        id: UUID,
        profile: Profile? = nil,
        location: Location,
        state: User.State,
        status: UserStatus,
        isFriend: Bool = true
    ) -> UserDetail {
        UserDetail(
            id: id,
            profile: profile,
            location: location,
            state: state,
            status: status,
            isFriend: isFriend
        )
    }
}

private extension UserDetail {
    init(
        id: UUID = UUID(),
        profile: PreviewData.Profile? = PreviewData.Profile.random,
        bio: String = "Demo",
        location: Location,
        state: User.State,
        status: UserStatus,
        statusDescription: String = "Demo",
        isFriend: Bool = true,
        dateJoined: Date = Date(),
        lastActivity: Date = Date()
    ) {
        self.init(
            ageVerificationStatus: .hidden,
            ageVerified: false,
            bio: bio,
            bioLinks: SafeDecodingArray(),
            avatarImageUrl: profile?.imageUrl(),
            avatarThumbnailUrl: profile?.imageUrl(),
            displayName: profile?.name ?? "",
            id: "usr_\(id.uuidString)",
            isFriend: isFriend,
            lastLogin: Date(),
            lastPlatform: "standalonewindows",
            profilePicOverride: profile?.imageUrl(),
            state: state,
            status: status,
            statusDescription: statusDescription,
            tags: UserTags(),
            userIcon: profile?.imageUrl(),
            location: location,
            friendKey: "",
            dateJoined: dateJoined,
            note: "",
            lastActivity: lastActivity,
            platform: .blank
        )
    }
}
