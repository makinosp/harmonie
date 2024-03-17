//
//  FriendsView.swift
//  friendplus
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct FriendsView: View {
    @EnvironmentObject var userData: UserData
    @State var onlineFriends: [Friend]
    @State var offlineFriends: [Friend]
    @State var recentylyFriends: [Friend]
    @State var listSelection: FriendListType?
    @State var friendSelection: Friend?
    @State var searchText: String
    let imageFrame = CGSize(width: 200, height: 150)
    let thumbnailFrame = CGSize(width: 32, height: 32)

    init(
        onlineFriends: [Friend] = [],
        offlineFriends: [Friend] = [],
        recentryFriends: [Friend] = []
    ) {
        self.onlineFriends = onlineFriends
        self.offlineFriends = offlineFriends
        self.recentylyFriends = recentryFriends
        searchText = ""
    }

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
            friendListView()
        }
        .sheet(item: $friendSelection) { friend in
            FriendDetailView(friend: UserDetail(friend: friend))
                .presentationDetents([.medium, .large])
        }
        .task {
            guard let onlineFriendsCount = userData.user?.onlineFriends.count else { return }
            while onlineFriends.count < onlineFriendsCount {
                onlineFriends.append(
                    contentsOf: await fetchFriends(
                        offset: onlineFriends.count,
                        offline: false
                    )
                )
            }
        }
        .task {
            offlineFriends = await fetchFriends(offset: 0, offline: true)
        }
    }

    /// Friend List branched by list type
    func friendListView() -> some View {
        List {
            if let listType = listSelection {
                if let status = listType.status {
                    let filteredFriends = onlineFriends.filter { $0.status == status.rawValue }
                    ForEach(filteredFriends) { friend in
                        rowView(friend)
                    }
                } else if listType == .all {
                    ForEach(onlineFriends) { friend in
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
                    ForEach(recentylyFriends) { friend in
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
    }

    /// Row view for friend list
    func rowView(_ friend: Friend) -> some View {
        HStack {
            AsyncImage(
                url: URL(string: friend.currentAvatarThumbnailImageUrl)) { image in
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

    /// Fetch friends from API
    func fetchFriends(offset: Int, offline: Bool) async -> [Friend] {
        guard !isPreview else { return [] }
        do {
            return try await FriendService.fetchFriends(
                userData.client,
                offset: offset,
                offline: offline
            )
        } catch {
            print(error)
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
