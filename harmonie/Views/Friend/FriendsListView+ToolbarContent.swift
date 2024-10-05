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
                            case .asc: IconSet.up.icon
                            case .desc: IconSet.down.icon
                            }
                        }
                    }
                }
            }
        } label: {
            IconSet.sort.icon
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
            IconSet.filter.icon
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
                            IconSet.check.icon
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
                        IconSet.check.icon
                    }
                }
            }
            ForEach(favoriteVM.favoriteGroups([.friend])) { favoriteGroup in
                Button {
                    friendVM.applyFilterFavoriteGroup(.favoriteGroup(favoriteGroup))
                } label: {
                    Label {
                        Text(favoriteGroup.displayName)
                    } icon: {
                        if friendVM.isCheckedFilterFavoriteGroups(.favoriteGroup(favoriteGroup)) {
                            IconSet.check.icon
                        }
                    }
                }
            }
        }
    }
}
