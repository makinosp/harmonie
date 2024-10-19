//
//  UserDetailMenuView.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/13.
//

import AsyncSwiftUI
import VRCKit

struct UserDetailToolbarMenu: View {
    @Environment(AppViewModel.self) var appVM
    @Environment(FavoriteViewModel.self) var favoriteVM
    @Environment(FriendViewModel.self) var friendVM
    @Environment(\.dismiss) private var dismiss
    @State private var isRequesting = false
    @State private var isPresentedAlert = false
    let user: UserDetail

    var body: some View {
        Menu {
            if user.isFriend {
                favoriteMenu
            }
            if let url = user.url {
                ShareLink(item: url)
            }
            if user.isFriend {
                presentUnfriendAlertButton
            }
        } label: {
            if isRequesting {
                ProgressView()
            } else {
                IconSet.dots.icon
            }
        }
        .alert("Unfriend", isPresented: $isPresentedAlert) {
            unfriendTaskButton
        } message: {
            Text("Are you sure you want to unfriend?")
        }
    }

    private var presentUnfriendAlertButton: Button<some View> {
        Button("Unfriend", systemImage: IconSet.unfriend.systemName, role: .destructive) {
            isPresentedAlert.toggle()
        }
    }

    private var unfriendTaskButton: Button<some View> {
        Button("Unfriend", role: .destructive) {
            Task {
                do {
                    try await appVM.services.friendService.unfriend(id: user.id)
                    try await friendVM.fetchAllFriends()
                } catch {
                    appVM.handleError(error)
                }
                dismiss()
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

    private func updateFavoriteAction(friendId: String, group: FavoriteGroup) async {
        guard let friend = friendVM.getFriend(id: friendId) else { return }
        defer { isRequesting = false }
        isRequesting = true
        do {
            try await favoriteVM.updateFavorite(
                service: appVM.services.favoriteService,
                friend: friend,
                targetGroup: group
            )
        } catch {
            appVM.handleError(error)
        }
    }
}
