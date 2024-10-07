//
//  UserDetailView+Actions.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/11.
//

import VRCKit

extension UserDetailView {
    func fetchInstance(id: String) async {
        do {
            defer { isRequesting = false }
            isRequesting = true
            instance = try await instanceService.fetchInstance(location: id)
        } catch {
            appVM.handleError(error)
        }
    }

    func updateFavoriteAction(friendId: String, group: FavoriteGroup) async {
        guard let friend = friendVM.getFriend(id: friendId) else { return }
        defer { isRequestingInMenu = false }
        isRequestingInMenu = true
        do {
            try await favoriteVM.updateFavorite(
                service: favoriteService,
                friend: friend,
                targetGroup: group
            )
        } catch {
            appVM.handleError(error)
        }
    }
}
