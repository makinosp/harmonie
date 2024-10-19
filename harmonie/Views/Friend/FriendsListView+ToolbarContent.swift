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
        Menu("", systemImage: IconSet.sort.systemName) {
            @Bindable var friendVM = friendVM
            Picker("", selection: $friendVM.sortType) {
                ForEach(SortType.allCases) { sortType in
                    Text(sortType.description).tag(sortType)
                }
            }
            .onChange(of: friendVM.sortType) {
                friendVM.applyFilters()
            }
        }
    }

    private var filterMenu: some View {
        Menu("", systemImage: IconSet.filter.systemName) {
            Button("Clear") {
                friendVM.clearFilters()
            }
            filterUserStatusMenu
            filterFavoriteGroupsMenu
        }
    }

    private var filterUserStatusMenu: some View {
        Menu("Statuses") {
            ForEach(FilterUserStatus.allCases) { filterUserStatus in
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
            ForEach(favoriteVM.favoriteGroups(.friend)) { favoriteGroup in
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
