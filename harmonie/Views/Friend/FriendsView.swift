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
    @EnvironmentObject var favoriteVM: FavoriteViewModel
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

    /// Friend List branched by list type
    var listView: some View {
        List(friendVM.filterFriends(
            text: searchString,
            statuses: typeFilters,
            filterFavoriteGroups: filterFavoriteGroups,
            favoriteFriends: favoriteVM.favoriteFriends
        )) { friend in
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
