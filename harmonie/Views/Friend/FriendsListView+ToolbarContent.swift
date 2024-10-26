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
                    Label(sortType.description, systemImage: sortType.icon.systemName)
                        .tag(sortType)
                }
            }
            .onChange(of: friendVM.sortType) {
                friendVM.applyFilters()
            }
        }
    }

    private var filterMenu: some View {
        Menu("", systemImage: IconSet.filter.systemName) {
            Button("Clear", systemImage: IconSet.clear.systemName) {
                friendVM.clearFilters()
            }
            filterUserStatusMenu
            filterFavoriteGroupsMenu
        }
    }

    private var filterUserStatusMenu: some View {
        Menu("Statuses") {
            Button("Clear", systemImage: IconSet.clear.systemName) {
                friendVM.filterUserStatus.removeAll()
            }
            ForEach(UserStatus.allCases) { userStatus in
                @Bindable var friendVM = friendVM
                let isOn = $friendVM.filterUserStatus.containsBinding(for: userStatus)
                Toggle(isOn: isOn) {
                    Text(userStatus.description)
                    Image(systemName: IconSet.circleFilled.systemName)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(userStatus.color)
                }
            }
        }
        .onChange(of: friendVM.filterUserStatus) {
            friendVM.applyFilters()
        }
    }

    private var filterFavoriteGroupsMenu: some View {
        Menu("Favorite Groups") {
            Button("Clear", systemImage: IconSet.clear.systemName) {
                friendVM.filterFavoriteGroups.removeAll()
            }
            ForEach(favoriteVM.favoriteGroups(.friend)) { favoriteGroup in
                @Bindable var friendVM = friendVM
                let isOn = $friendVM.filterFavoriteGroups.containsBinding(for: favoriteGroup)
                Toggle(favoriteGroup.displayName, isOn: isOn)
            }
        }
        .onChange(of: friendVM.filterFavoriteGroups) {
            friendVM.applyFilters()
        }
    }
}
