//
//  FavoritesView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/16.
//

import VRCKit
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var userData: UserData
    @State var friendsInFavoriteGroups: [FriendsInFavoriteGroup] = []

    typealias FavoritesWithGroupId = (favoriteGroupId: String, favorites: [Favorite])
    typealias FriendsInFavoriteGroup = (favoriteGroupId: String, friends: [UserDetail])

    var body: some View {
        List {
            ForEach(favoriteFriendGroups) { group in
                Section(header: Text(group.displayName)) {
                    ForEach(favoritesFromGroupId(group.id)) { friend in
                        Text(friend.displayName)
                    }
                }
            }
        }
        .task {
            do {
                userData.favoriteGroups = try await FavoriteService.listFavoriteGroups(userData.client).get()
                let favoritesWithGroupId = try await fetchFavoritesInGroups()
                friendsInFavoriteGroups = try await fetchFriendsInGroups(favoritesWithGroupId)
            } catch {
                print(error)
            }
        }
    }

    func fetchFavoritesInGroups() async throws -> [FavoritesWithGroupId] {
        guard let favoriteGroups = userData.favoriteGroups else { return [] }

        var results: [FavoritesWithGroupId] = []
        try await withThrowingTaskGroup(of: FavoritesWithGroupId.self) { taskGroup in
            for favoriteGroup in favoriteGroups.filter({ $0.type == .friend }) {
                taskGroup.addTask {
                    try await FavoritesWithGroupId(
                        favoriteGroupId: favoriteGroup.id,
                        favorites: FavoriteService.listFavorites(
                            userData.client,
                            type: .friend,
                            tag: favoriteGroup.name
                        ).get()
                    )
                }
            }
            for try await friendsInFavoriteGroup in taskGroup {
                results.append(friendsInFavoriteGroup)
            }
        }
        return results
    }

    func fetchFriendsInGroups(
        _ favoritesWithGroupId: [FavoritesWithGroupId]
    ) async throws -> [FriendsInFavoriteGroup] {
        var results: [FriendsInFavoriteGroup] = []
        try await withThrowingTaskGroup(of: FriendsInFavoriteGroup.self) { taskGroup in
            for favoriteGroup in favoritesWithGroupId {
                taskGroup.addTask {
                    try await FriendsInFavoriteGroup(
                        favoriteGroupId: favoriteGroup.favoriteGroupId,
                        friends: UserService.fetchUsers(
                            userData.client,
                            userIds: favoriteGroup.favorites.map(\.favoriteId)
                        ).get()
                    )
                }
            }
            for try await friendsInFavoriteGroup in taskGroup {
                results.append(friendsInFavoriteGroup)
            }
        }
        return results
    }

    var favoriteFriendGroups: [FavoriteGroup] {
        userData.favoriteGroups?.filter { $0.type == .friend } ?? []
    }

    func favoritesFromGroupId(_ id: String) -> [UserDetail] {
        friendsInFavoriteGroups.first(where: { $0.favoriteGroupId == id } )?.friends ?? []
    }
}
