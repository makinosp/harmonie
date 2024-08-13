//
//  FriendsView+Filters.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/12.
//

import SwiftUI
import VRCKit

extension FriendsView {
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
            Button {
                filterFavoriteGroupAction(.all)
            } label: {
                Label {
                    Text("All")
                } icon: {
                    if isCheckedFilterFavoriteGroups(.all) {
                        Image(systemName: Constants.IconName.check)
                    }
                }
            }
            ForEach(favoriteVM.favoriteFriendGroups) { group in
                Button {
                    filterFavoriteGroupAction(.favoriteGroup(group))
                } label: {
                    Label {
                        Text(group.displayName)
                    } icon: {
                        if isCheckedFilterFavoriteGroups(.favoriteGroup(group)) {
                            Image(systemName: Constants.IconName.check)
                        }
                    }
                }
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

    func isCheckedStatusFilter(_ listType: FriendViewModel.FriendListType) -> Bool {
        switch listType {
        case .all:
            typeFilters.isEmpty
        case .status(let status):
            typeFilters.contains(status)
        }
    }

    func isCheckedFilterFavoriteGroups(_ listType: FriendViewModel.FilterFavoriteGroups) -> Bool {
        switch listType {
        case .all:
            filterFavoriteGroups.isEmpty
        case .favoriteGroup(let favoriteGroup):
            filterFavoriteGroups.contains(favoriteGroup)
        }
    }
}
