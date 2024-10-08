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
        ToolbarItem { toolbarMenu }
    }

    private var toolbarMenu: some View {
        Menu {
            if user.isFriend {
                favoriteMenu
            }
            if let url = user.url {
                ShareLink(item: url)
            }
        } label: {
            if isRequestingInMenu {
                ProgressView()
            } else {
                IconSet.dots.icon
            }
        }
    }

    private var favoriteMenu: some View {
        Menu {
            ForEach(favoriteVM.favoriteGroups(.friend)) { group in
                favoriteMenuItem(group: group)
            }
        } label: {
            Label {
                Text("Favorite")
            } icon: {
                if favoriteVM.isAdded(friendId: user.id) {
                    IconSet.favoriteFilled.icon
                } else {
                    IconSet.favorite.icon
                }
            }
        }
    }

    private func favoriteMenuItem(group: FavoriteGroup) -> some View {
        AsyncButton {
            await updateFavoriteAction(friendId: user.id, group: group)
        } label: {
            Label {
                Text(group.displayName)
            } icon: {
                if favoriteVM.isInFavoriteGroup(
                    friendId: user.id,
                    groupId: group.id
                ) {
                    IconSet.check.icon
                }
            }
        }
    }
}
