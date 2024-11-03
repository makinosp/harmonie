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
        let onlineFriendsSet: [FriendSet] = (0..<50).map { count in
            let id = UUID()
            return switch count {
            case ..<5:
                FriendSet(id: id, location: .id(Self.instance1.id), status: .active)
            case ..<10:
                FriendSet(id: id, location: .id(Self.instance2.id), status: .active)
            case ..<15:
                FriendSet(id: id, location: .id(Self.instance2.id), status: .joinMe)
            case ..<20:
                FriendSet(id: id, location: .private, status: .askMe)
            case ..<25:
                FriendSet(id: id, location: .id(Self.instance1.id), status: .joinMe)
            case ..<30:
                FriendSet(id: id, location: .private, status: .busy)
            default:
                FriendSet(id: id, location: .offline, status: .offline)
            }
        }

        var userDetails = onlineFriendsSet.map(\.userDetail)
        userDetails.append(PreviewData.previewUserDetail(id: previewUserId, instance: Self.instance1))

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
