//
//  FriendsView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct FriendsView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var friendViewModel: FriendViewModel
    @State var offlineFriends: [Friend] = []
    @State var recentlyFriends: [Friend] = []
    @State var listSelection: FriendListType?
    @State var friendSelection: Friend?
    @State var searchText: String = ""
    let thumbnailSize = CGSize(width: 32, height: 32)
    let fetchRecentlyFriendsCount = 10

    var body: some View {
        NavigationSplitView {
            List(FriendListType.allCases, selection: $listSelection) { item in
                NavigationLink(value: item) {
                    Label {
                        Text(item.description)
                    } icon: {
                        item.icon
                    }
                }
            }
            .navigationTitle("Friends")
        } detail: {
            VStack {
                friendListView
                if listSelection == .recently {
                    Button {
                        Task {
                            let friends = await fetchFriendsByIds(offset: recentlyFriends.count)
                            recentlyFriends.append(contentsOf: friends)
                        }
                    } label: {
                        Image(systemName: "arrow.down.circle")
                        Text("Load more")
                    }
                    .padding()
                }
            }
        }
        .sheet(item: $friendSelection) { friend in
            FriendDetailView(friend: UserDetail(friend: friend))
                .presentationDetents([.medium, .large])
                .presentationBackground(Color(UIColor.systemGroupedBackground))
        }
    }

    /// Friend List branched by list type
    var friendListView: some View {
        List {
            if let listType = listSelection {
                if let status = listType.status {
                    let filteredFriends = friendViewModel.onlineFriends.filter { $0.status == status }
                    ForEach(filteredFriends) { friend in
                        rowView(friend)
                    }
                } else if listType == .all {
                    ForEach(friendViewModel.onlineFriends) { friend in
                        rowView(friend)
                    }
                } else if listType == .offline {
                    ForEach(offlineFriends) { friend in
                        rowView(friend)
                            .task {
                                await additionalFetchOfflineFriends(friend: friend)
                            }
                    }
                } else if listType == .recently {
                    ForEach(recentlyFriends) { friend in
                        rowView(friend)
                    }
                }
            }
        }
        .listStyle(.inset)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always)
        )
        .navigationTitle(listSelection?.description ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: listSelection) {
            if let listType = listSelection, listType == .offline {
                offlineFriends = await fetchFriends(offset: 0, offline: true)
            } else if let listType = listSelection, listType == .recently {
                recentlyFriends = await fetchFriendsByIds(offset: 0)
            }
        }
    }

    /// Row view for friend list
    func rowView(_ friend: Friend) -> some View {
        HStack {
            HACircleImage(
                imageUrl: (friend.userIcon.isEmpty ? friend.currentAvatarThumbnailImageUrl : friend.userIcon) ?? "",
                size: thumbnailSize
            )
            Text(friend.displayName)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            friendSelection = friend
        }
    }

    /// Fetch friends from API
    func fetchFriends(offset: Int, offline: Bool) async -> [Friend] {
        do {
            return try await FriendService.fetchFriends(
                userData.client,
                offset: offset,
                offline: offline
            )
        } catch {
            return []
        }
    }

    /// Fetch friends by IDs from API
    func fetchFriendsByIds(offset: Int) async -> [Friend] {
        guard let friendIds = userData.user?.friends else { return [] }
        do {
            return try await UserService.fetchUsers(
                userData.client,
                userIds: friendIds
                    .reversed()
                    .dropFirst(offset)
                    .prefix(fetchRecentlyFriendsCount)
                    .map(\.description)
            )
            .map(\.friend)
        } catch {
            return []
        }
    }

    /// Additional fetch offline friends from API
    func additionalFetchOfflineFriends(friend: Friend) async {
        guard let offlineFriendsCount = userData.user?.offlineFriends.count,
              let fetchThreshold = offlineFriends.dropLast(5).last else {
            return
        }
        if offlineFriends.count < offlineFriendsCount,
           friend.id == fetchThreshold.id {
            await offlineFriends.append(
                contentsOf: fetchFriends(
                    offset: offlineFriends.count,
                    offline: false
                )
            )
        }
    }
}
