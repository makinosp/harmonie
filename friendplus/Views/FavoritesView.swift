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
    @State var friendsInFavoriteGroups: [FriendsInFavoriteGroup]?
    @State var friendSelection: UserDetail?

    typealias FavoritesWithGroupId = (favoriteGroupId: String, favorites: [Favorite])
    typealias FriendsInFavoriteGroup = (favoriteGroupId: String, friends: [UserDetail])
    typealias FriendsResultSet = (favoriteGroupId: String, result: Result<[UserDetail], ErrorResponse>)

    let thumbnailFrame = CGSize(width: 32, height: 32)

    var body: some View {
        NavigationSplitView {
            if friendsInFavoriteGroups != nil {
                List {
                    ForEach(userData.favoriteFriendGroups) { group in
                        Section(header: Text(group.displayName)) {
                            ForEach(favoritesFromGroupId(group.id)) { friend in
                                rowView(friend)
                            }
                        }
                    }
                }
                .sheet(item: $friendSelection) { friend in
                    FriendDetailView(friend: friend)
                        .presentationDetents([.medium, .large])
                }
                .navigationTitle("Favorites")
            } else {
                ProgressView()
                    .task {
                        do {
                            let favoritesWithGroupId = try await fetchFavoritesInGroups()
                            friendsInFavoriteGroups = try await fetchFriendsInGroups(favoritesWithGroupId)
                        } catch {
                            print(error)
                        }
                    }
            }
        } detail: { EmptyView() }
    }

    func rowView(_ friend: UserDetail) -> some View {
        HStack {
            let imageUrl = friend.userIcon.isEmpty ? friend.currentAvatarThumbnailImageUrl : friend.userIcon
            AsyncImage(
                url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(size: thumbnailFrame)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(size: thumbnailFrame)
                }
            Text(friend.displayName)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            friendSelection = friend
        }
    }

    /// Fetch a list of favorite IDs for each favorite group
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

    /// Fetch friend info from favorite IDs
    func fetchFriendsInGroups(
        _ favoritesWithGroupId: [FavoritesWithGroupId]
    ) async throws -> [FriendsInFavoriteGroup] {
        var results: [FriendsInFavoriteGroup] = []
        try await withThrowingTaskGroup(of: FriendsResultSet.self) { taskGroup in
            for favoriteGroup in favoritesWithGroupId {
                taskGroup.addTask {
                    try await FriendsResultSet(
                        favoriteGroupId: favoriteGroup.favoriteGroupId,
                        result: UserService.fetchUsers(
                            userData.client,
                            userIds: favoriteGroup.favorites.map(\.favoriteId)
                        )
                    )
                }
            }
            for try await result in taskGroup {
                switch result.result {
                case .success(let friends):
                    results.append(FriendsInFavoriteGroup(favoriteGroupId: result.favoriteGroupId, friends: friends))
                case .failure(let error):
                    print(error)
                }
            }
        }
        return results
    }

    /// Lookup friends list from group ID
    func favoritesFromGroupId(_ id: String) -> [UserDetail] {
        friendsInFavoriteGroups?.first(where: { $0.favoriteGroupId == id } )?.friends ?? []
    }
}
