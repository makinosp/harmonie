//
//  FriendsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct FriendsView: View {
    @EnvironmentObject var friendVM: FriendViewModel
    @State var listSelection: FriendListType? = .all
    @State var friendSelection: Friend?
    @State var searchString: String = ""
    let thumbnailSize = CGSize(width: 32, height: 32)
    let fetchRecentlyFriendsCount = 10

    /// Defining friend list types and icons
    enum FriendListType: Hashable {
        case all, status(UserStatus), recently
    }

    var body: some View {
        NavigationStack {
            listView
                .navigationTitle("Friends")
                .searchable(text: $searchString)
                .toolbar { toolbarContent }
        }
        .sheet(item: $friendSelection) { friend in
            UserDetailView(id: friend.id)
                .presentationDetents([.medium, .large])
                .presentationBackground(Color(UIColor.systemGroupedBackground))
        }
    }

    var toolbarContent: some ToolbarContent {
        ToolbarItem {
            Menu {
                ForEach(FriendListType.allCases) { listType in
                    Button(listType.description) {}
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
            }
        }
    }

    /// Friend List branched by list type
    var listView: some View {
        List {
            ForEach(friendVM.filterFriends(by: .recently, searchString: searchString)) { friend in
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
        .listStyle(.inset)
    }
}

extension FriendsView.FriendListType: Identifiable {
    var id: Int {
        self.description.hash
    }
}

extension FriendsView.FriendListType: CustomStringConvertible {
    var description: String {
        switch self {
        case .all:
            return "All Online"
        case .status(let status):
            return status.description
        case .recently:
            return "Recently"
        }
    }
}

extension FriendsView.FriendListType: CaseIterable {
    static var allCases: [FriendsView.FriendListType] {
        [
            .all,
            .status(.active),
            .status(.joinMe),
            .status(.askMe),
            .status(.busy),
            .status(.offline),
            .recently
        ]
    }
}
