//
//  PreviewDataProvider.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/13.
//

import Foundation
import VRCKit

final class PreviewData: Sendable {
    static let shared = PreviewData()
    private let previewUserId = UUID()
    let friends: [Friend]
    let userDetails: [UserDetail]

    static let imageBaseURL = "https://images2.imgbox.com"
    static let iconImageUrl = URL(string: "\(imageBaseURL)/44/8f/IQToHkKa_o.jpg")

    private init() {
        let onlineFriendsSet: [FriendSet] = [
            (0..<10).map { _ in FriendSet(world: Self.bar, status: .joinMe) },
            (0..<5).map { _ in FriendSet(world: Self.chillRoom, status: .active) },
            (0..<3).map { _ in FriendSet(world: Self.fuji, status: .joinMe) },
            (0..<2).map { _ in FriendSet(world: Self.chinatown, status: .active) },
            [FriendSet(world: Self.nightCity, status: .joinMe)],
            (0..<25).map { _ in FriendSet(location: .private, status: .busy) }
        ].flatMap { $0 }

        var userDetails = onlineFriendsSet.map(\.userDetail)
        userDetails.append(PreviewData.userDetail(id: previewUserId, instance: Self.instance))

        self.userDetails = userDetails
        self.friends = onlineFriendsSet.map(\.friend)
    }

    var previewUser: User {
        User(
            activeFriends: [],
            allowAvatarCopying: false,
            bio: "This is the demo user.",
            bioLinks: SafeDecodingArray(),
            currentAvatar: "",
            avatarImageUrl: PreviewData.iconImageUrl,
            avatarThumbnailUrl: PreviewData.iconImageUrl,
            dateJoined: Date(),
            displayName: "Demo User",
            friendKey: "",
            friends: friends.map(\.id),
            homeLocation: "",
            id: "usr_\(previewUserId.uuidString)",
            isFriend: false,
            lastActivity: Date(),
            lastLogin: Date(),
            lastPlatform: "standalonewindows",
            offlineFriends: offlineFriends.map(\.id),
            onlineFriends: onlineFriends.map(\.id),
            pastDisplayNames: [],
            profilePicOverride: PreviewData.iconImageUrl,
            state: .active,
            status: .active,
            statusDescription: "status",
            tags: UserTags(),
            twoFactorAuthEnabled: true,
            userIcon: PreviewData.iconImageUrl,
            userLanguage: nil,
            userLanguageCode: nil,
            presence: Presence()
        )
    }
}

private extension Presence {
    init() {
        self.init(
            groups: [],
            id: UUID().uuidString,
            instance: "",
            instanceType: "",
            platform: .android,
            status: .active,
            travelingToInstance: "",
            travelingToWorld: "",
            world: ""
        )
    }
}
