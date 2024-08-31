//
//  FriendsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct FriendsView: View {
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel
    @State var selected: Selected?

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            listView
        } detail: {
            Text("Select a friend")
        }
        .navigationSplitViewStyle(.balanced)
    }

    var bindFilterText: Binding<String> {
        @Bindable var friendVM = friendVM
        return $friendVM.filterText
    }

    @ToolbarContentBuilder var toolbarContent: some ToolbarContent {
        ToolbarItem { sortMenu }
        ToolbarItem { filterMenu }
    }

    /// Friend List branched by list type
    var listView: some View {
        List(friendVM.filterFriends(favoriteFriends: favoriteVM.favoriteFriends)) { friend in
            Button {
                selected = Selected(id: friend.id)
            } label: {
                LabeledContent {
                    Constants.Icon.forward
                } label: {
                    Label {
                        Text(friend.displayName)
                    } icon: {
                        ZStack {
                            Circle()
                                .foregroundStyle(friend.status.color)
                                .frame(size: Constants.IconSize.thumbnailOutside)
                            CircleURLImage(
                                imageUrl: friend.thumbnailUrl,
                                size: Constants.IconSize.thumbnail
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
        }
        .navigationTitle("Friends")
        .searchable(text: bindFilterText)
        .toolbar { toolbarContent }
        .navigationDestination(item: $selected) { selected in
            UserDetailPresentationView(id: selected.id)
                .id(selected.id)
        }
    }
}
