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
    @State var friends: [Friend]
    @State var offlineFriends: [Friend]
    @State var recentylyFriends: [Friend]
    @State var listSelection: FriendListType?
    @State var friendSelection: Friend?
    let imageFrame = CGSize(width: 200, height: 150)
    let thumbnailFrame = CGSize(width: 32, height: 32)

    init(
        friends: [Friend] = [],
        offlineFriends: [Friend] = [],
        recentryFriends: [Friend] = []
    ) {
        self.friends = friends
        self.offlineFriends = offlineFriends
        self.recentylyFriends = recentryFriends
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
            if let listSelection = listSelection {
                friendListView(listSelection)
                    .navigationTitle(listSelection.description)
            }
        }
        .sheet(item: $friendSelection) { friend in
            detailView(friend)
                .presentationDetents([.medium, .large])
        }
        .task {
            friends = await fetchFriend(offset: 0, offline: false)
        }
    }

    /// Fetch friends from API
    func fetchFriend(offset: Int, offline: Bool) async -> [Friend] {
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

    /// Friend List branched by list type
    func friendListView(_ listType: FriendListType) -> some View {
        List {
            if let status = listType.status {
                let filteredFriends = friends.filter { $0.status == status.rawValue }

                // TODO: Additional fetch
//                let fetchThreshold = filteredFriends.dropLast(5).last
                ForEach(filteredFriends) { friend in
                    rowView(friend)
//                        .task {
//                            guard let fetchThreshold = fetchThreshold else { return }
//                            if friend.id == fetchThreshold.id {
//                                await friends.append(
//                                    contentsOf: fetchFriend(
//                                        offset: friends.count,
//                                        offline: false)
//                                )
//                            }
//                        }
                }
            } else if listType == .all {
                ForEach(friends) { friend in
                    rowView(friend)
                }
            } else if listType == .offline {
                // TODO: Additional fetch
                ForEach(offlineFriends) { friend in
                    rowView(friend)
                }
            } else if listType == .recently {
                ForEach(recentylyFriends) { friend in
                    rowView(friend)
                }
            }
        }
        .listStyle(.inset)
        .task {
            if listType == .offline {
                offlineFriends = await fetchFriend(offset: 0, offline: true)
            }
        }
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

    /// Friends detail view
    func detailView(_ friend: Friend) -> some View {
        ScrollView {
            VStack {
                AsyncImage(
                    url: URL(string: friend.currentAvatarThumbnailImageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                VStack {
                    Text(friend.displayName)
                        .font(.headline)
                    Text(friend.statusDescription)
                        .font(.body)
                }
                .padding()
                if let bio = friend.bio {
                    Text(bio)
                        .font(.body)
                        .foregroundStyle(Color.gray)
                        .padding()
                }
                Text(friend.lastLogin.description)
                if let bioLinks = friend.bioLinks {
                    ForEach(
                        Array(bioLinks.enumerated()),
                        id: \.element
                    ) { (index, urlString) in
                        if let url = URL(string: urlString) {
                            Link("Link \((index + 1).description)", destination: url)
                        }
                    }
                }
            }
        }
    }
}

#Preview("FriendsView") {
    FriendsView(
        friends: [
            Friend(
                bio: "bio",
                bioLinks: ["https://twitter.com/makinovrc"],
                currentAvatarImageUrl: "https://api.vrchat.cloud/api/1/file/file_29cc0315-390e-44b1-b9f1-6eb7601ca5fd/2/file",
                currentAvatarThumbnailImageUrl: "https://api.vrchat.cloud/api/1/image/file_29cc0315-390e-44b1-b9f1-6eb7601ca5fd/2/512",
                developerType: "string",
                displayName: "displayName",
                id: UUID().uuidString,
                isFriend: true,
                lastLogin: Date(),
                lastPlatform: "lastPlatform",
                status: "active",
                statusDescription: "statusDescription",
                tags: ["tag"]
            )
        ]
    )
    .environmentObject(UserData())
}
