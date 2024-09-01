//
//  UserDetailView+Toolbar.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/19.
//

import AsyncSwiftUI
import VRCKit

extension UserDetailView {
    @ToolbarContentBuilder var toolbar: some ToolbarContent {
        if user.isFriend {
            ToolbarItem { friendMenu }
        }
        ToolbarItem(placement: .keyboard) {
            AsyncButton("Save") {
                if note != user.note {
                    await saveNote()
                }
            }
        }
    }

    private var friendMenu: some View {
        Menu {
            favoriteMenu
        } label: {
            Constants.Icon.dots
        }
    }

    private var favoriteMenu: some View {
        Menu {
            ForEach(favoriteVM.favoriteFriendGroups) { group in
                favoriteMenuItem(group: group)
            }
        } label: {
            Label {
                Text("Favorite")
            } icon: {
                if favoriteVM.isAdded(friendId: user.id) {
                    Constants.Icon.favoriteFilled
                } else {
                    Constants.Icon.favorite
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
                    Constants.Icon.check
                }
            }
        }
    }
}
