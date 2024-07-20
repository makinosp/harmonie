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
    @State var listSelection: FriendListType?
    @State var friendSelection: Friend?
    @State var searchString: String = ""
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
            .searchable(
                text: $searchString,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .navigationTitle("Friends")
        } detail: {
            listView
        }
        .sheet(item: $friendSelection) { friend in
            UserDetailView(id: friend.id)
                .presentationDetents([.medium, .large])
                .presentationBackground(Color(UIColor.systemGroupedBackground))
        }
    }

    /// Friend List branched by list type
    var listView: some View {
        List {
            if let listType = listSelection {
                ForEach(friendVM.filterFriends(by: listType, searchString: searchString)) { friend in
                    rowView(friend)
                }
            }
        }
        .listStyle(.inset)
        .searchable(
            text: $searchString,
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

    /// Defining friend list types and icons
    enum FriendListType: Hashable {
        case all
        case status(UserStatus)
        case recently

        @ViewBuilder
        var icon: some View {
            switch self {
            case .all:
                Image(systemName: "person.crop.rectangle.stack.fill")
            case .status(let status):
                Image(systemName: "person.crop.circle.fill")
                    .foregroundStyle(status.color)
            case .recently:
                Image(systemName: "person.crop.circle.badge.clock.fill")
            }
        }
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
