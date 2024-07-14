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
    typealias FavoriteFriend = (favoriteGroupId: String, friends: [Friend])
    @Published var favoriteGroups: [FavoriteGroup] = []
    @Published var favoriteFriends: [FavoriteFriend] = []
    let friendVM: FriendViewModel
    let service: any FavoriteServiceProtocol

    /// Initializes the view model with the specified HTTP client.
    /// - Parameter client: The `APIClient` instance used for making network requests.
    init(friendVM: FriendViewModel, service: any FavoriteServiceProtocol) {
        self.friendVM = friendVM
        self.service = service
    }

    /// A filtered list of favorite groups that contain only friend-type groups.
    /// It retrieves friend-type groups from the `favoriteGroups` property.
    var favoriteFriendGroups: [FavoriteGroup] {
        favoriteGroups.filter { $0.type == .friend }
    }

    /// Asynchronously fetches and updates the favorite groups and their details.
    /// - Throws: An error if any network request or decoding operation fails.
    func fetchFavorite() async throws {
        favoriteGroups = try await service.listFavoriteGroups()
        let favoriteDetails: [FavoriteDetail] = try await service.fetchFavoriteGroupDetails(
            favoriteGroups: favoriteGroups
        )
        let favoriteDetailsOfFriends = favoriteDetails.filter { $0.allFavoritesAre(.friend) }
        favoriteFriends = favoriteDetailsOfFriends.map { favoriteDetail in
            (
                favoriteGroupId: favoriteDetail.id,
                friends: favoriteDetail.favorites.compactMap { favorite in
                    friendVM.getFriend(id: favorite.favoriteId)
                }
            )
        }
    }

    /// Find out which favorite group the friend belongs to from the friend ID and return that favorite ID
    /// If it does not exist, nil is returned
    /// Finds the favorite group ID that contains a friend with the specified friend ID.
    /// - Parameter friendId: The ID of the friend to search for.
    /// - Returns: The ID of the favorite group that contains the friend, or nil if the friend is not found.
    func findFavoriteGroupIdForFriend(friendId: String) -> String? {
        let includingFavorite = favoriteFriends.first(where: { favoriteFriendDetail in
            favoriteFriendDetail.friends.contains(where: { friend in
                friend.id == friendId
            })
        })
        return includingFavorite?.favoriteGroupId
    }

    func isAdded(friendId: String) -> Bool {
        findFavoriteGroupIdForFriend(friendId: friendId) != nil
    }

    /// Adds a friend to a specified favorite group.
    /// - Parameters:
    ///   - friend: The `Friend` object representing the friend to add.
    ///   - groupId: The ID of the favorite group to which the friend should be added.
    func addFriendToFavoriteGroup(friend: Friend, groupId: String) {
        let groupIndex = favoriteFriends.firstIndex(where: { $0.favoriteGroupId == groupId })
        guard let groupIndex = groupIndex else { return }
        favoriteFriends[groupIndex].friends.insert(friend, at: 0)
    }

    /// Removes a friend from the favorite group identified by `groupId`.
    /// If the group is found, the friend with the specified ID is removed from the group's friends list.
    /// - Parameters:
    ///   - friendId: The ID of the friend to remove.
    ///   - groupId: The ID of the favorite group from which the friend should be removed.
    func removeFriendFromFavoriteGroup(friendId: String, groupId: String) {
        let groupIndex = favoriteFriends.firstIndex(where: { $0.favoriteGroupId == groupId })
        guard let groupIndex = groupIndex else { return }
        favoriteFriends[groupIndex].friends = favoriteFriends[groupIndex].friends.filter { $0.id != friendId }
    }

    /// Looks up the list of favorite friends belonging to the group identified by `groupId`.
    /// - Parameter groupId: The ID of the favorite group to look up.
    /// - Returns: An optional array of `UserDetail` objects representing favorite friends in the specified group.
    func getFavoriteFriends(_ groupId: String) -> [Friend]? {
        return favoriteFriends.first(where: { $0.favoriteGroupId == groupId } )?.friends
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
    ///   - friendId: The friend's id whose favorite status is being updated.
    ///   - targetGroup: The `FavoriteGroup` object representing the target group for the favorite status.
    func updateFavorite(friendId: String, targetGroup: FavoriteGroup) async throws {
        guard let friend = friendVM.getFriend(id: friendId) else { return }
        let sourceGroupId = findFavoriteGroupIdForFriend(friendId: friend.id)
        if let sourceGroupId = sourceGroupId {
            _ = try await service.removeFavorite(favoriteId: friend.id)
            removeFriendFromFavoriteGroup(friendId: friend.id, groupId: sourceGroupId)
        }
        if targetGroup.id != sourceGroupId {
            _ = try await service.addFavorite(
                type: .friend,
                favoriteId: friend.id,
                tag: targetGroup.name
            )
            addFriendToFavoriteGroup(friend: friend, groupId: targetGroup.id)
        }
    }
}
