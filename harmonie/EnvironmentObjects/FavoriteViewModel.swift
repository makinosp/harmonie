//
//  FavoriteViewModel.swift
//  harmonie
//
//  Created by makinosp on 2024/06/09.
//

import Foundation
import VRCKit

@MainActor
class FavoriteViewModel: ObservableObject {
    @Published var favoriteGroups: [FavoriteGroup]?
    @Published var favoriteFriendDetails: [FavoriteFriendDetail]?

    var favoriteFriendGroups: [FavoriteGroup]? {
        favoriteGroups?.filter { $0.type == .friend }
    }

    // fetch favorite data
    func fetchFavorite(_ client: APIClient) async throws {
        favoriteGroups = try await FavoriteService.listFavoriteGroups(client)
        guard let favoriteGroups = favoriteGroups else { return }
        let favorites = try await FavoriteService.fetchFavoriteGroupDetails(
            client,
            favoriteGroups: favoriteGroups
        )
        favoriteFriendDetails = try await FavoriteService.fetchFriendsInGroups(
            client,
            favorites: favorites
        )
    }

    /// Find out which favorite group the friend belongs to from the friend ID and return that favorite ID
    /// If it does not exist, nil is returned
    func findOutFriendFromFavorites(_ friendId: String) -> String? {
        guard let favoriteFriendDetails = favoriteFriendDetails else { return nil }
        let includingFavorite = favoriteFriendDetails.first(where: { favoriteFriendDetail in
            favoriteFriendDetail.friends.contains(where: { friend in
                friend.id == friendId
            })
        })
        return includingFavorite?.favoriteGroupId
    }

    func addFriendInFavorite(friend: UserDetail, groupId: String) {
        guard var groups = favoriteFriendDetails,
              let groupIndex = groups.firstIndex(where: { $0.favoriteGroupId == groupId }) else { return }
        groups[groupIndex].friends.insert(friend, at: 0)
        favoriteFriendDetails = groups
    }

    func removeFriendFromFavorite(friendId: String, groupId: String) {
        guard var groups = favoriteFriendDetails,
              let groupIndex = groups.firstIndex(where: { $0.favoriteGroupId == groupId }) else { return }
        groups[groupIndex].friends = groups[groupIndex].friends.filter { $0.id != friendId }
        favoriteFriendDetails = groups
    }

    /// Lookup favorite friend list by group ID
    func lookUpFavoriteFriends(_ groupId: String) -> [UserDetail]? {
        favoriteFriendDetails?.first(where: { $0.favoriteGroupId == groupId } )?.friends
    }

    func isIncludedFriendInFavorite(friendId: String, groupId: String) -> Bool {
        guard let favoriteFriendDetails = lookUpFavoriteFriends(groupId) else { return false }
        return favoriteFriendDetails.contains(where: { friend in
            friend.id == friendId
        })
    }
}
