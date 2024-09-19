//
//  FriendsListView+ToolbarContent.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/12.
//

import SwiftUI
import VRCKit

extension FriendsListView {
    @ToolbarContentBuilder var toolbarContent: some ToolbarContent {
        ToolbarItem { sortMenu }
        ToolbarItem { filterMenu }
    }

    private var sortMenu: some View {
        Menu {
            ForEach(FriendViewModel.SortType.allCases) { sortType in
                Button {
                    if friendVM.sortType == sortType {
                        friendVM.sortOrder.toggle()
                    } else {
                        friendVM.sortType = sortType
                        friendVM.sortOrder = .asc
                    }
                    friendVM.applyFilters()
                } label: {
                    Label {
                        Text(sortType.description)
                    } icon: {
                        if friendVM.sortType == sortType {
                            switch friendVM.sortOrder {
                            case .asc: Constants.Icon.up
                            case .desc: Constants.Icon.down
                            }
                        }
                    }
                }
            }
        } label: {
            Constants.Icon.sort
        }
    }

    private var filterMenu: some View {
        Menu {
            Button("Clear") {
                friendVM.clearFilters()
            }
            filterUserStatusMenu
            filterFavoriteGroupsMenu
        } label: {
            Constants.Icon.filter
        }
    }

    private var filterUserStatusMenu: some View {
        Menu("Statuses") {
            ForEach(FriendViewModel.FilterUserStatus.allCases) { filterUserStatus in
                Button {
                    friendVM.applyFilterUserStatus(filterUserStatus)
                } label: {
                    Label {
                        Text(filterUserStatus.description)
                    } icon: {
                        if friendVM.isCheckedFilterUserStatus(filterUserStatus) {
                            Constants.Icon.check
                        }
                    }
                }
            }
        }
    }

    private var filterFavoriteGroupsMenu: some View {
        Menu("Favorite Groups") {
            Button {
                friendVM.applyFilterFavoriteGroup(.all)
            } label: {
                Label {
                    Text("All")
                } icon: {
                    if friendVM.isCheckedFilterFavoriteGroups(.all) {
                        Constants.Icon.check
                    }
                }
            }
            ForEach(favoriteVM.favoriteFriendGroups) { favoriteGroup in
                Button {
                    friendVM.applyFilterFavoriteGroup(.favoriteGroup(favoriteGroup))
                } label: {
                    Label {
                        Text(favoriteGroup.displayName)
                    } icon: {
                        if friendVM.isCheckedFilterFavoriteGroups(.favoriteGroup(favoriteGroup)) {
                            Constants.Icon.check
                        }
                    }
                }
            }
        }
    }
}
