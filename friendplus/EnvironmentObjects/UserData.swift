//
//  UserData.swift
//  friendplus
//
//  Created by makinosp on 2024/03/09.
//

import SwiftUI
import VRCKit

class UserData: ObservableObject {
    typealias FavoriteFriendDetail = (favoriteGroupId: String, friends: [UserDetail])
    typealias FavoriteDetail = (favoriteGroupId: String, favorites: [Favorite])

    @Published var client = APIClient()
    @Published var user: User?
    @Published var favoriteGroups: [FavoriteGroup]?
    @Published var favoriteFriendDetails: [FavoriteFriendDetail]?

    var favoriteFriendGroups: [FavoriteGroup]? {
        favoriteGroups?.filter { $0.type == .friend }
    }

    /// Fetch a list of favorite IDs for each favorite group
    func fetchFavoriteGroupDetails() async throws -> [FavoriteDetail] {
        guard let favoriteGroups = self.favoriteGroups else { return [] }

        var results: [FavoriteDetail] = []
        try await withThrowingTaskGroup(of: FavoriteDetail.self) { taskGroup in
            for favoriteGroup in favoriteGroups.filter({ $0.type == .friend }) {
                taskGroup.addTask {
                    try await FavoriteDetail(
                        favoriteGroupId: favoriteGroup.id,
                        favorites: FavoriteService.listFavorites(
                            self.client,
                            type: .friend,
                            tag: favoriteGroup.name
                        ).get()
                    )
                }
            }
            for try await favoriteGroupDetail in taskGroup {
                results.append(favoriteGroupDetail)
            }
        }
        return results
    }

    /// Fetch friend details from favorite IDs
    func fetchFriendsInGroups(
        _ favorites: [FavoriteDetail]
    ) async throws -> [FavoriteFriendDetail] {
        typealias FriendsResultSet = (favoriteGroupId: String, result: Result<[UserDetail], ErrorResponse>)
        var results: [FavoriteFriendDetail] = []
        try await withThrowingTaskGroup(of: FriendsResultSet.self) { taskGroup in
            for favoriteGroup in favorites {
                taskGroup.addTask {
                    try await FriendsResultSet(
                        favoriteGroupId: favoriteGroup.favoriteGroupId,
                        result: UserService.fetchUsers(
                            self.client,
                            userIds: favoriteGroup.favorites.map(\.favoriteId)
                        )
                    )
                }
            }
            for try await result in taskGroup {
                switch result.result {
                case .success(let friends):
                    results.append(FavoriteFriendDetail(favoriteGroupId: result.favoriteGroupId, friends: friends))
                case .failure(let error):
                    print(error)
                }
            }
        }
        return results
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
