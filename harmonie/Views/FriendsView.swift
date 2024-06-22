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
            friendListView
        }
        .sheet(item: $friendSelection) { friend in
            UserDetailView(id: friend.id)
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
                    ForEach(friendViewModel.offlineFriends) { friend in
                        rowView(friend)
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
    }

    /// Row view for friend list
    func rowView(_ friend: Friend) -> some View {
        HStack {
            CircleURLImage(
                imageUrl: friend.userIconUrl,
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
}
