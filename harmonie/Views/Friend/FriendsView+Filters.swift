//
//  FriendsView+Filters.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/12.
//

import SwiftUI
import VRCKit

extension FriendsView {
    var filterUserStatus: some View {
        Menu("Statuses") {
            ForEach(FriendViewModel.FilterUserStatus.allCases) { filterUserStatus in
                Button {
                    friendVM.applyFilterUserStatus(filterUserStatus)
                } label: {
                    Label {
                        Text(filterUserStatus.description)
                    } icon: {
                        if friendVM.isCheckedFilterUserStatus(filterUserStatus) {
                            Image(systemName: Constants.IconName.check)
                        }
                    }
                }
            }
        }
    }

    var sortArrowIconName: String {
        switch friendVM.sortOrder {
        case .asc: Constants.IconName.arrowUp
        case .desc: Constants.IconName.arrowDown
        }
    }

    var sortMenu: some View {
        Menu {
            ForEach(FriendViewModel.SortType.allCases) { sortType in
                Button {
                    // sort action
                } label: {
                    Label {
                        Text(sortType.description)
                    } icon: {
                        if friendVM.sortType == sortType {
                            Image(systemName: sortArrowIconName)
                        }
                    }
                }
            }
        } label: {
            Image(systemName: Constants.IconName.sort)
        }
    }

    var filterFavoriteGroups: some View {
        Menu("Favorite Groups") {
            Button {
                friendVM.applyFilterFavoriteGroup(.all)
            } label: {
                Label {
                    Text("All")
                } icon: {
                    if friendVM.isCheckedFilterFavoriteGroups(.all) {
                        Image(systemName: Constants.IconName.check)
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
                            Image(systemName: Constants.IconName.check)
                        }
                    }
                }
            }
        }
    }
}
