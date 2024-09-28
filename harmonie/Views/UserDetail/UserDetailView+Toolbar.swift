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
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            AsyncButton {
                if note != user.note {
                    isRequesting = true
                    await saveNote()
                    isRequesting = false
                }
                isFocusedNoteField = false
            } label: {
                if isRequesting {
                    ProgressView()
                } else {
                    Text("Save")
                }
            }
            .disabled(isRequesting)
        }
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
            Constants.Icon.dots
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
                if favoriteVM.isInFavoriteGroup(
                    friendId: user.id,
                    groupId: group.id
                ) {
                    Constants.Icon.check
                }
            }
        }
    }
}
