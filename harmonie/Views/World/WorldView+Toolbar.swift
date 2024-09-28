//
//  WorldView+Toolbar.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/28.
//

import AsyncSwiftUI
import VRCKit

extension WorldView {
    @ToolbarContentBuilder var toolbar: some ToolbarContent {
        ToolbarItem { toolbarMenu }
    }

    private var toolbarMenu: some View {
        Menu {
            favoriteMenu
            if let url = world.url {
                ShareLink(item: url)
            }
        } label: {
            Constants.Icon.dots
        }
    }

    private var favoriteMenu: some View {
        Menu {
            ForEach(favoriteVM.favoriteGroups(.world)) { group in
                favoriteMenuItem(group: group)
            }
        } label: {
            Label {
                Text("Favorite")
            } icon: {
                if favoriteVM.favoriteWorlds.contains(where: { $0.id == world.id }) {
                    Constants.Icon.favoriteFilled
                } else {
                    Constants.Icon.favorite
                }
            }
        }
    }

    private func favoriteMenuItem(group: FavoriteGroup) -> some View {
        AsyncButton {
            await updateFavorite(world: world, group: group)
        } label: {
            Label {
                Text(group.displayName)
            } icon: {
                if favoriteVM.isInFavoriteGroup(
                    worldId: world.id,
                    groupName: group.name
                ) {
                    Constants.Icon.check
                }
            }
        }
    }

    func updateFavorite(world: World, group: FavoriteGroup) async {
        do {
            try await favoriteVM.updateFavorite(
                service: favoriteService,
                world: world,
                targetGroup: group
            )
        } catch {
            appVM.handleError(error)
        }
    }
}
