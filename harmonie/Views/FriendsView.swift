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
                ForEach(filterFriends(listType: listType)) { friend in
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

    func isIncluded(target: String) -> Bool {
        searchString.isEmpty || target.range(of: searchString, options: .caseInsensitive) != nil
    }

    func filterFriends(listType: FriendListType) -> [Friend] {
        switch listType {
        case .all:
            return friendViewModel.onlineFriends.filter {
                isIncluded(target: $0.displayName)
            }
        case .recently:
            return recentlyFriends.filter {
                isIncluded(target: $0.displayName)
            }
        case .status(let status):
            switch status {
            case .offline:
                return friendViewModel.offlineFriends.filter {
                    isIncluded(target: $0.displayName)
                }
            default:
                return friendViewModel.onlineFriends
                    .filter { $0.status == status }
                    .filter {
                        isIncluded(target: $0.displayName)
                    }
            }
        }
    }

    /// Defining friend list types and icons
    enum FriendListType: Hashable {
        case all
        case status(User.Status)
        case recently

        @ViewBuilder
        var icon: some View {
            switch self {
            case .all:
                Image(systemName: "person.crop.rectangle.stack.fill")
            case .status(let status):
                statusIcon(status: status)
            case .recently:
                Image(systemName: "person.crop.circle.badge.clock.fill")
            }
        }
    }

    static func statusIcon(status: User.Status) -> some View {
        switch status {
        case .active:
            Image(systemName: "person.crop.circle.fill")
                .foregroundStyle(Color.green)
        case .joinMe:
            Image(systemName: "person.crop.circle.fill")
                .foregroundStyle(Color.cyan)
        case .askMe:
            Image(systemName: "person.crop.circle.fill")
                .foregroundStyle(Color.orange)
        case .busy:
            Image(systemName: "person.crop.circle.fill")
                .foregroundStyle(Color.red)
        case .offline:
            Image(systemName: "person.crop.circle.fill")
                .foregroundStyle(Color.gray)
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
            .recently,
        ]
    }
}
