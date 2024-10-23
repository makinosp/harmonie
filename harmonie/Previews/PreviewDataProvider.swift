//
//  PreviewDataProvider.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/13.
//

import Foundation
import VRCKit

final class PreviewDataProvider: Sendable {
    static let shared = PreviewDataProvider()
    private let previewUserId = UUID()
    let friends: [Friend]
    let userDetails: [UserDetail]
    let instances: [Instance]

    static let iconImageUrl = URL(string: "https://www.mediafire.com/convkey/f444/fmivuoxwvdvnucx9g.jpg")

    private init() {
        let instance = Self.instance(worldId: UUID(), instanceId: 0)
        let onlineFriendsSet: [FriendSet] = (0..<50).map { count in
            let id = UUID()
            return switch count {
            case ..<10:
                Self.friendSet(id: id, location: .id(instance.id), status: .active)
            case ..<20:
                Self.friendSet(id: id, location: .private, status: .askMe)
            case ..<30:
                Self.friendSet(id: id, location: .id(instance.id), status: .joinMe)
            case ..<40:
                Self.friendSet(id: id, location: .private, status: .busy)
            default:
                Self.friendSet(id: id, location: .offline, status: .offline)
            }
        }
        var userDetails = onlineFriendsSet.map(\.userDetail)
        userDetails.append(PreviewDataProvider.previewUserDetail(id: previewUserId, instance: instance))

        self.userDetails = userDetails
        self.friends = onlineFriendsSet.map(\.friend)
        self.instances = [instance]
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
            presence: Presence(
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
        )
    }
}
