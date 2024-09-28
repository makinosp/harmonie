//
//  PreviewDataProvider.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/13.
//

import Foundation
import VRCKit

final class PreviewDataProvider: Sendable {
    typealias FriendSet = (friend: Friend, userDetail: UserDetail)
    static let shared = PreviewDataProvider()
    private let previewUserId = UUID()
    let friends: [Friend]
    let userDetails: [UserDetail]
    let instances: [Instance]

    static let iconImageUrl = URL(string: "https://www.mediafire.com/convkey/f444/fmivuoxwvdvnucx9g.jpg")

    private init() {
        let instance = Self.generateInstance(worldId: UUID(), instanceId: 0)
        let onlineFriendsSet: [FriendSet] = (0..<50).map { count in
            let id = UUID()
            return switch count {
            case ..<10:
                Self.generateFriendSet(id: id, location: .id(instance.id), status: .active)
            case ..<20:
                Self.generateFriendSet(id: id, location: .private, status: .askMe)
            case ..<30:
                Self.generateFriendSet(id: id, location: .id(instance.id), status: .joinMe)
            case ..<40:
                Self.generateFriendSet(id: id, location: .private, status: .busy)
            default:
                Self.generateFriendSet(id: id, location: .offline, status: .offline)
            }
        }
        var userDetails = onlineFriendsSet.map(\.userDetail)
        userDetails.append(PreviewDataProvider.previewUserDetail(id: previewUserId, instance: instance))

        self.userDetails = userDetails
        self.friends = onlineFriendsSet.map(\.friend)
        self.instances = [instance]
    }

    private static func previewUserDetail(id: UUID, instance: Instance) -> UserDetail {
        PreviewDataProvider.generateUserDetail(
            id: id,
            location: .id(instance.id),
            state: .active,
            status: .active,
            isFriend: false
        )
    }

    var onlineFriends: [Friend] {
        friends.filter { $0.status != .offline }
    }

    var offlineFriends: [Friend] {
        friends.filter { $0.status == .offline }
    }

    var previewUser: User {
        User(
            activeFriends: [],
            allowAvatarCopying: false,
            bio: "This is the demo user.",
            bioLinks: SafeDecodingArray(),
            currentAvatar: "",
            avatarImageUrl: PreviewDataProvider.iconImageUrl,
            avatarThumbnailUrl: PreviewDataProvider.iconImageUrl,
            dateJoined: Date(),
            displayName: "usr_\(previewUserId.uuidString.prefix(8))",
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
            profilePicOverride: PreviewDataProvider.iconImageUrl,
            state: .active,
            status: .active,
            statusDescription: "status",
            tags: UserTags(),
            twoFactorAuthEnabled: true,
            userIcon: PreviewDataProvider.iconImageUrl,
            userLanguage: nil,
            userLanguageCode: nil,
            presence: User.Presence()
        )
    }

    private static func generateFriendSet(
        id: UUID,
        location: Location,
        status: UserStatus
    ) -> FriendSet {
        (
            PreviewDataProvider.generateFriend(
                id: id,
                location: location,
                status: status
            ),
            PreviewDataProvider.generateUserDetail(
                id: id,
                location: location,
                state: status == .offline ? .offline : .active,
                status: status
            )
        )
    }

    static func generateFriend(
        id: UUID,
        location: Location,
        status: UserStatus
    ) -> Friend {
        Friend(
            bio: "Biography",
            bioLinks: SafeDecodingArray(),
            avatarImageUrl: iconImageUrl,
            avatarThumbnailUrl: iconImageUrl,
            displayName: "User_\(id.uuidString.prefix(8))",
            id: "usr_\(id.uuidString)",
            isFriend: true,
            lastLogin: Date(),
            lastPlatform: "standalonewindows",
            platform: .blank,
            profilePicOverride: iconImageUrl,
            status: status,
            statusDescription: "",
            tags: UserTags(),
            userIcon: iconImageUrl,
            location: location,
            friendKey: ""
        )
    }

    static func generateFriend() -> Friend {
        generateFriend(id: UUID(), location: .offline, status: .offline)
    }

    static func generateUserDetail(
        id: UUID,
        location: Location,
        state: User.State,
        status: UserStatus,
        isFriend: Bool = true
    ) -> UserDetail {
        UserDetail(
            bio: "Demo",
            bioLinks: SafeDecodingArray(),
            avatarImageUrl: iconImageUrl,
            avatarThumbnailUrl: iconImageUrl,
            displayName: "User_\(id.uuidString.prefix(8))",
            id: "usr_\(id.uuidString)",
            isFriend: isFriend,
            lastLogin: Date(),
            lastPlatform: "standalonewindows",
            profilePicOverride: iconImageUrl,
            state: state,
            status: status,
            statusDescription: "Demo",
            tags: UserTags(),
            userIcon: iconImageUrl,
            location: location,
            friendKey: "",
            dateJoined: Date(),
            note: "",
            lastActivity: Date(),
            platform: .blank
        )
    }

    static func generateInstance(worldId: UUID, instanceId: Int) -> Instance {
        Instance(
            active: true,
            capacity: 32,
            full: false,
            groupAccessType: nil,
            id: "wrld_\(worldId):\(instanceId)",
            instanceId: instanceId.description,
            location: .id("wrld_\(worldId.uuidString)"),
            name: "DummyInstance_\(instanceId)",
            ownerId: "usr_\(UUID().uuidString)",
            permanent: false,
            platforms: Instance.Platforms(
                android: 0,
                ios: 0,
                standalonewindows: 0
            ),
            recommendedCapacity: 32,
            region: .jp,
            tags: [],
            type: .public,
            userCount: 0,
            world: generateWorld(worldId: worldId)
        )
    }

    static func generateInstance() -> Instance {
        generateInstance(worldId: UUID(), instanceId: 0)
    }
}
