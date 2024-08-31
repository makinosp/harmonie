//
//  UserDetailView+Actions.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/11.
//

import VRCKit

extension UserDetailView {
    func fetchInstance() async {
        let service = appVM.isDemoMode
        ? InstancePreviewService(client: appVM.client)
        : InstanceService(client: appVM.client)
        do {
            instance = try await service.fetchInstance(location: user.location)
        } catch {
            appVM.handleError(error)
        }
    }

    func updateFavorite(friendId: String, group: FavoriteGroup) async {
        guard let friend = friendVM.getFriend(id: friendId) else { return }
        do {
            try await favoriteVM.updateFavorite(
                friend: friend,
                targetGroup: group
            )
        } catch {
            appVM.handleError(error)
        }
    }

    func saveNote() async {
        let service = appVM.isDemoMode
        ? UserNotePreviewService(client: appVM.client)
        : UserNoteService(client: appVM.client)
        do {
            if user.note.isEmpty {
                try await service.clearUserNote(targetUserId: user.id)
            } else {
                _ = try await service.updateUserNote(
                    targetUserId: user.id,
                    note: note
                )
            }
        } catch {
            appVM.handleError(error)
        }
    }
}
