//
//  FavoriteViewModel.swift
//  harmonie
//
//  Created by makinosp on 2024/06/09.
//

import Foundation
import VRCKit

/// View model for managing favorite groups and their associated details.
/// Acts as an interface between the UI and backend services for handling favorite group operations.
@MainActor
class FavoriteViewModel: ObservableObject {
    @Published var favoriteGroups: [FavoriteGroup]? = nil
    @Published var favoriteFriendDetails: [FavoriteFriendDetail]? = nil
    var client: APIClient

    /// Initializes the view model with the specified HTTP client.
    /// - Parameter client: The `APIClient` instance used for making network requests.
    init(client: APIClient) {
        self.client = client
    }

    /// A filtered list of favorite groups that contain only friend-type groups.
    /// It retrieves friend-type groups from the `favoriteGroups` property.
    var favoriteFriendGroups: [FavoriteGroup]? {
        favoriteGroups?.filter { $0.type == .friend }
    }

    /// Asynchronously fetches and updates the favorite groups and their details.
    /// - Throws: An error if any network request or decoding operation fails.
    func fetchFavorite() async throws {
        // favoriteGroups = try await FavoriteService.listFavoriteGroups(client)
        // guard let favoriteGroups = favoriteGroups else { return }
        // let favorites = try await FavoriteService.fetchFavoriteGroupDetails(
        //     client,
        //     favoriteGroups: favoriteGroups
        // )
        // favoriteFriendDetails = try await FavoriteService.fetchFriendsInGroups(
        //     client,
        //     favorites: favorites
        // )
    }

    /// Find out which favorite group the friend belongs to from the friend ID and return that favorite ID
    /// If it does not exist, nil is returned
    /// Finds the favorite group ID that contains a friend with the specified friend ID.
    /// - Parameter friendId: The ID of the friend to search for.
    /// - Returns: The ID of the favorite group that contains the friend, or nil if the friend is not found.
    func findFavoriteGroupIdForFriend(friendId: String) -> String? {
        guard let favoriteFriendDetails = favoriteFriendDetails else { return nil }
        let includingFavorite = favoriteFriendDetails.first(where: { favoriteFriendDetail in
            favoriteFriendDetail.friends.contains(where: { friend in
                friend.id == friendId
            })
        })
        return includingFavorite?.favoriteGroupId
    }

    /// Adds a friend to a specified favorite group.
    /// - Parameters:
    ///   - friend: The `UserDetail` object representing the friend to add.
    ///   - groupId: The ID of the favorite group to which the friend should be added.
    func addFriendToFavoriteGroup(friend: UserDetail, groupId: String) {
        guard var groups = favoriteFriendDetails,
              let groupIndex = groups.firstIndex(where: { $0.favoriteGroupId == groupId }) else { return }
        groups[groupIndex].friends.insert(friend, at: 0)
        favoriteFriendDetails = groups
    }

    /// Removes a friend from the favorite group identified by `groupId`.
    /// If the group is found, the friend with the specified ID is removed from the group's friends list.
    /// - Parameters:
    ///   - friendId: The ID of the friend to remove.
    ///   - groupId: The ID of the favorite group from which the friend should be removed.
    func removeFriendFromFavoriteGroup(friendId: String, groupId: String) {
        guard var groups = favoriteFriendDetails,
              let groupIndex = groups.firstIndex(where: { $0.favoriteGroupId == groupId }) else { return }
        groups[groupIndex].friends = groups[groupIndex].friends.filter { $0.id != friendId }
        favoriteFriendDetails = groups
    }

    /// Looks up the list of favorite friends belonging to the group identified by `groupId`.
    /// - Parameter groupId: The ID of the favorite group to look up.
    /// - Returns: An optional array of `UserDetail` objects representing favorite friends in the specified group.
    func getFavoriteFriends(_ groupId: String) -> [UserDetail]? {
        favoriteFriendDetails?.first(where: { $0.favoriteGroupId == groupId } )?.friends
    }

    /// Checks if a friend with the specified ID is included in the list of favorite friends
    /// belonging to the group identified by `groupId`.
    /// - Parameters:
    ///   - friendId: The ID of the friend to check.
    ///   - groupId: The ID of the favorite group to check for the friend.
    /// - Returns: `true` if the friend is found in the group's favorite friends list, otherwise `false`.
    func isFriendInFavoriteGroup(friendId: String, groupId: String) -> Bool {
        guard let favoriteFriendDetails = getFavoriteFriends(groupId) else { return false }
        return favoriteFriendDetails.contains { $0.id == friendId }
    }

    /// Updates the favorite status for a user based on the specified target group.
    /// If the user is currently favorited in a different group, removes them from that group.
    /// If the target group differs from the current favorite group, adds the user to the new group.
    /// - Parameters:
    ///   - user: The `UserDetail` object representing the user whose favorite status is being updated.
    ///   - targetGroup: The `FavoriteGroup` object representing the target group for the favorite status.
    func updateFavorite(user: UserDetail, targetGroup: FavoriteGroup) async throws {
        let sourceGroupId = findFavoriteGroupIdForFriend(friendId: user.id)
        if let sourceGroupId = sourceGroupId {
            _ = try await FavoriteService.removeFavorite(client, favoriteId: user.id)
            removeFriendFromFavoriteGroup(friendId: user.id, groupId: sourceGroupId)
        }
        if targetGroup.id != sourceGroupId {
            _ = try await FavoriteService.addFavorite(
                client,
                type: .friend,
                favoriteId: user.id,
                tag: targetGroup.name
            )
            addFriendToFavoriteGroup(friend: user, groupId: targetGroup.id)
        }
    }
}
