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
    @EnvironmentObject private var favoriteVM: FavoriteViewModel
    @State var typeFilters: Set<UserStatus> = []
    @State var filterFavoriteGroups: Set<FavoriteGroup> = []
    @State var selected: Selected?
    @State var searchString: String = ""

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            listView
        } detail: {
            Text("Select a friend")
        }
        .navigationSplitViewStyle(.balanced)
    }

    var toolbarContent: some ToolbarContent {
        ToolbarItem {
            Menu {
                filter
            } label: {
                Image(systemName: Constants.IconName.filter)
            }
        }
    }

    @ViewBuilder var filter: some View {
        Menu("Statuses") {
            ForEach(FriendViewModel.FriendListType.allCases) { listType in
                Button {
                    statusFilterAction(listType)
                } label: {
                    Label {
                        Text(listType.description)
                    } icon: {
                        if isCheckedStatusFilter(listType) {
                            Image(systemName: Constants.IconName.check)
                        }
                    }
                }
            }
        }
        Menu("Favorite Groups") {
            ForEach(favoriteVM.favoriteFriendGroups) { group in
                Button {} label: {
                    Text(group.displayName)
                }
            }
        }
    }

    func statusFilterAction(_ listType: FriendViewModel.FriendListType) {
        switch listType {
        case .all:
            typeFilters.removeAll()
        case .status(let status):
            if typeFilters.contains(status) {
                typeFilters.remove(status)
            } else {
                typeFilters.insert(status)
            }
        }
    }

    func filterFavoriteGroupAction(_ type: FriendViewModel.FilterFavoriteGroups) {
        switch type {
        case .all:
            filterFavoriteGroups.removeAll()
        case .favoriteGroup(let favoriteGroup):
            if filterFavoriteGroups.contains(favoriteGroup) {
                filterFavoriteGroups.remove(favoriteGroup)
            } else {
                filterFavoriteGroups.insert(favoriteGroup)
            }
        }
    }

    func isCheckedStatusFilter(_ listType: FriendViewModel.FriendListType) -> Bool {
        switch listType {
        case .all:
            typeFilters.isEmpty
        case .status(let status):
            typeFilters.contains(status)
        }
    }

    /// Friend List branched by list type
    var listView: some View {
        List(friendVM.filterFriends(text: searchString, statuses: typeFilters)) { friend in
            Button {
                selected = Selected(id: friend.id)
            } label: {
                HStack {
                    ZStack {
                        Circle()
                            .foregroundStyle(friend.status.color)
                            .frame(size: Constants.IconSize.thumbnailOutside)
                        CircleURLImage(
                            imageUrl: friend.userIconUrl,
                            size: Constants.IconSize.thumbnail
                        )
                    }
                    Text(friend.displayName)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
        }
        .navigationTitle("Friends")
        .searchable(text: $searchString)
        .toolbar { toolbarContent }
        .navigationDestination(item: $selected) { selected in
            UserDetailPresentationView(id: selected.id)
                .id(selected.id)
        }
    }
}

extension FriendViewModel.FriendListType: CaseIterable {
    static var allCases: [FriendViewModel.FriendListType] {
        [
            .all,
            .status(.active),
            .status(.joinMe),
            .status(.askMe),
            .status(.busy),
            .status(.offline)
        ]
    }
}
