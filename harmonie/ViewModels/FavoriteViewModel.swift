//
//  FavoriteViewModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/09.
//

import Observation
import VRCKit

/// View model for managing favorite groups and their associated details.
/// Acts as an interface between the UI and backend services for handling favorite group operations.
@Observable @MainActor
final class FavoriteViewModel {
    var favoriteGroups: [FavoriteGroup] = []
    var favoriteFriends: [FavoriteFriend] = []
    var favoriteWorlds: [FavoriteWorld] = []
    var segment: FavoriteViewSegment = .all

    /// Filters and returns the favorite groups of a specific type.
    /// - Parameter type: The `FavoriteType` to filter the favorite groups by.
    /// - Returns: An array of `FavoriteGroup` that matches the specified type.
    func favoriteGroups(_ type: FavoriteType) -> [FavoriteGroup] {
        favoriteGroups.filter { $0.type == type }
    }

    var isSelectedEmpty: Bool {
        switch segment {
        case .all:
            favoriteGroups(.friend).isEmpty && favoriteWorldGroups.isEmpty
        case .friends:
            favoriteGroups(.friend).isEmpty
        case .world:
            favoriteWorldGroups.isEmpty
        }
    }

    /// Filters the favorite groups by the given set of favorite types,
    /// and returns a dictionary where the keys are the favorite types.
    /// - Parameter types: A set of `FavoriteType` values used to filter the favorite groups.
    /// - Returns: A dictionary where the keys are `FavoriteType` and the values are arrays of `FavoriteGroup`.
    func favoriteGroups(_ types: Set<FavoriteType>) -> [FavoriteType: [FavoriteGroup]] {
        let filtered = favoriteGroups.filter { types.contains($0.type) }
        return Dictionary(grouping: filtered) { $0.type }
    }

    func getFavoriteGroup(id: FavoriteGroup.ID) -> FavoriteGroup? {
        favoriteGroups.first { $0.id == id }
    }

    func getFavoriteGroup(name: String) -> FavoriteGroup? {
        favoriteGroups.first { $0.name == name }
    }

    func updateFavoriteGroup(
        service: FavoriteServiceProtocol,
        id: FavoriteGroup.ID,
        displayName: String,
        visibility: FavoriteGroup.Visibility
    ) async throws {
        guard let source = getFavoriteGroup(id: id) else { return }
        _ = try await service.updateFavoriteGroup(
            source: source,
            displayName: displayName,
            visibility: visibility
        )
        let index = favoriteGroups.firstIndex { $0.id == source.id }
        guard let index = index else { return }
        favoriteGroups[index] = FavoriteGroup(source: source, displayName: displayName, visibility: visibility)
    }

    // MARK: - Friend

    /// Asynchronously fetches and updates the favorite groups and their details.
    /// - Parameters:
    ///   - service: Any `FavoriteServiceProtocol` service.
    ///   - friendVM: The `FriendViewModel` view model.
    func fetchFavoriteFriends(service: FavoriteServiceProtocol, friendVM: FriendViewModel) async throws {
        favoriteGroups = try await service.listFavoriteGroups()
        let favoriteDetails = try await service.fetchFavoriteList(favoriteGroups: favoriteGroups)
        let favoriteDetailsOfFriends = favoriteDetails.filter { $0.allFavoritesAre(.friend) }
        favoriteFriends = favoriteDetailsOfFriends.map { favoriteDetail in
            FavoriteFriend(
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
    func favoriteGroupId(friendId: Friend.ID) -> FavoriteFriend.ID? {
        favoriteFriends.first { $0.friends.contains { $0.id == friendId } }?.favoriteGroupId
    }

    func isAdded(friendId: Friend.ID) -> Bool {
        favoriteGroupId(friendId: friendId) != nil
    }

    /// Adds a friend to a specified favorite group.
    /// - Parameters:
    ///   - friend: The `Friend` object representing the friend to add.
    ///   - groupId: The ID of the favorite group to which the friend should be added.
    func addFriendToFavoriteGroup(friend: Friend, groupId: FavoriteFriend.ID) {
        let index = favoriteFriends.firstIndex { $0.favoriteGroupId == groupId }
        guard let index = index else { return }
        let favoriteFriend = favoriteFriends[index]
        favoriteFriends[index] = FavoriteFriend(
            favoriteGroupId: favoriteFriend.favoriteGroupId,
            friends: [friend] + favoriteFriend.friends
        )
    }

    /// Removes a friend from the favorite group identified by `groupId`.
    /// If the group is found, the friend with the specified ID is removed from the group's friends list.
    /// - Parameters:
    ///   - friendId: The ID of the friend to remove.
    ///   - groupId: The ID of the favorite group from which the friend should be removed.
    func removeFromFavoriteGroup(friendId: Friend.ID, groupId: FavoriteFriend.ID) {
        let index = favoriteFriends.firstIndex { $0.favoriteGroupId == groupId }
        guard let index = index else { return }
        let favoriteFriend = favoriteFriends[index]
        favoriteFriends[index] = FavoriteFriend(
            favoriteGroupId: favoriteFriend.favoriteGroupId,
            friends: favoriteFriend.friends.filter { $0.id != friendId }
        )
    }

    /// Looks up the list of favorite friends belonging to the group identified by `groupId`.
    /// - Parameter groupId: The ID of the favorite group to look up.
    /// - Returns: An optional array of `UserDetail` objects representing favorite friends in the specified group.
    func getFavoriteFriends(_ groupId: FavoriteGroup.ID) -> [Friend]? {
        favoriteFriends.first { $0.favoriteGroupId == groupId }?.friends
    }

    /// Checks if a friend with the specified ID is included in the list of favorite friends
    /// belonging to the group identified by `groupId`.
    /// - Parameters:
    ///   - friendId: The ID of the friend to check.
    ///   - groupId: The ID of the favorite group to check for the friend.
    /// - Returns: `true` if the friend is found in the group's favorite friends list, otherwise `false`.
    func isInFavoriteGroup(friendId: Friend.ID, groupId: FavoriteGroup.ID) -> Bool {
        guard let favoriteFriendDetails = getFavoriteFriends(groupId) else { return false }
        return favoriteFriendDetails.contains { $0.id == friendId }
    }

    /// Updates the favorite status for a user based on the specified target group.
    /// If the user is currently favorited, remove it from the group.
    /// If the target group differs from the current favorite group, adds the user to the new group.
    /// - Parameters:
    ///   - service: Any `FavoriteServiceProtocol` service.
    ///   - friendId: The ID of friend whose favorite status is being updated.
    ///   - targetGroup: The `FavoriteGroup` object representing the target group for the favorite status.
    func updateFavorite(service: FavoriteServiceProtocol, friend: Friend, targetGroup: FavoriteGroup) async throws {
        let sourceGroupId = favoriteGroupId(friendId: friend.id)
        if let sourceGroupId = sourceGroupId {
            _ = try await service.removeFavorite(favoriteId: friend.id)
            removeFromFavoriteGroup(friendId: friend.id, groupId: sourceGroupId)
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

    // MARK: - World

    func fetchFavoritedWorlds(service: WorldServiceProtocol) async throws {
        favoriteWorlds = try await service.fetchFavoritedWorlds(n: 100)
    }

    func getFavoriteWorldsByGroup(groupName: String) -> [FavoriteWorld] {
        favoriteWorlds.filter { $0.favoriteGroup == groupName }
    }

    var favoriteWorldGroups: [FavoriteWorldGroup] {
        favoriteGroups(.world).map { group in
            FavoriteWorldGroup(
                group: group,
                worlds: getFavoriteWorldsByGroup(groupName: group.name)
            )
        }
    }

    func isInFavoriteGroup(worldId: FavoriteWorld.ID, groupName: String) -> Bool {
        guard let favoriteWorld = favoriteWorlds.first(where: { $0.id == worldId }) else { return false }
        return favoriteWorld.favoriteGroup == groupName
    }

    /// Removes a world from the favorite list.
    /// - Parameter id: The `worldId` of the world to be removed.
    func removeWorldFromFavorite(worldId id: FavoriteWorld.ID) {
        favoriteWorlds = favoriteWorlds.filter { $0.id != id }
    }

    /// Updates the favorite status for a world based on the specified target group.
    /// If the world is currently favorited, remove it from the group.
    /// If the target group differs from the current favorite group, adds the world to the new group.
    /// - Parameters:
    ///   - service: Any `FavoriteServiceProtocol` service.
    ///   - worldId: The ID of the world to update.
    ///   - targetGroup: The `FavoriteGroup` where the world should be added.
    func updateFavorite(
        service: FavoriteServiceProtocol,
        world: World,
        targetGroup: FavoriteGroup
    ) async throws {
        let source = favoriteWorlds.first { $0.id == world.id }
        if let sourceGroupName = source?.favoriteGroup,
           let sourceGroup = getFavoriteGroup(name: sourceGroupName) {
            _ = try await service.removeFavorite(favoriteId: world.id)
            removeWorldFromFavorite(worldId: world.id)
            guard sourceGroup.id != targetGroup.id else { return }
        }
        let tag = targetGroup.name
        _ = try await service.addFavorite(
            type: .world,
            favoriteId: world.id,
            tag: targetGroup.name
        )
        favoriteWorlds.append(FavoriteWorld(world: world, favoriteGroup: tag))
    }
}
