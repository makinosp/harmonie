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

    static let imageBaseURL = "https://images2.imgbox.com"
    static let iconImageUrl = URL(string: "\(imageBaseURL)/44/8f/IQToHkKa_o.jpg")

    private init() {
        let instance = Self.instance1
        let onlineFriendsSet: [FriendSet] = (0..<50).map { count in
            let id = UUID()
            return switch count {
            case ..<10:
                FriendSet(id: id, location: .id(instance.id), status: .active)
            case ..<20:
                FriendSet(id: id, location: .private, status: .askMe)
            case ..<30:
                FriendSet(id: id, location: .id(instance.id), status: .joinMe)
            case ..<40:
                FriendSet(id: id, location: .private, status: .busy)
            default:
                FriendSet(id: id, location: .offline, status: .offline)
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
            profilePicOverride: PreviewDataProvider.iconImageUrl,
            state: .active,
            status: .active,
            statusDescription: "status",
            tags: UserTags(),
            twoFactorAuthEnabled: true,
            userIcon: PreviewDataProvider.iconImageUrl,
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
