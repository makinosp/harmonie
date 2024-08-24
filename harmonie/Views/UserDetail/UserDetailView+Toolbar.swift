//
//  UserDetailView+Toolbar.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/19.
//

import AsyncSwiftUI
import VRCKit

extension UserDetailView {
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu("Actions", systemImage: Constants.IconName.dots) {
                if user.isFriend {
                    Menu {
                        ForEach(favoriteVM.favoriteFriendGroups) { group in
                            favoriteMenuItem(group: group)
                        }
                    } label: {
                        Label {
                            Text("Favorite")
                        } icon: {
                            Image(systemName: favoriteIconName)
                        }
                    }
                }
            }
        }
    }

    private func favoriteMenuItem(group: FavoriteGroup) -> some View {
        AsyncButton {
            await updateFavorite(friendId: user.id, group: group)
        } label: {
            Label {
                Text(group.displayName)
            } icon: {
                if favoriteVM.isFriendInFavoriteGroup(
                    friendId: user.id,
                    groupId: group.id
                ) {
                    Image(systemName: Constants.IconName.check)
                }
            }
        }
    }

    var favoriteIconName: String {
        favoriteVM.isAdded(friendId: user.id)
        ? Constants.IconName.favoriteFilled
        : Constants.IconName.favorite
    }
}
