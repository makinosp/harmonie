//
//  FriendsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct FriendsView: View {
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel
    @State private var selected: String?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        @Bindable var friendVM = friendVM
        NavigationSplitView(columnVisibility: $columnVisibility) {
            FriendsListView(selected: $selected)
                .navigationTitle("Friends")
        } detail: {
            if let selected = selected {
                UserDetailPresentationView(id: selected)
                    .id(selected)
            } else {
                ContentUnavailableView {
                    Label {
                        Text("Select a Friend")
                    } icon: {
                        Constants.Icon.friends
                    }
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .searchable(
            text: $friendVM.filterText,
            placement: .navigationBarDrawer(displayMode: .always)
        )
        .onSubmit(of: .search) {
            friendVM.applyFilters()
        }
        .task {
            friendVM.setFavoriteFriends(favoriteVM.favoriteFriends)
        }
    }
}

#Preview {
    let appVM = AppViewModel(isPreviewMode: true)
    let friendVM = FriendViewModel(user: PreviewDataProvider.shared.previewUser)
    let favoriteVM = FavoriteViewModel()
    FriendsView()
        .environment(appVM)
        .environment(friendVM)
        .environment(favoriteVM)
        .task {
            do {
                try await friendVM.fetchAllFriends(service: FriendPreviewService(client: appVM.client))
                try await favoriteVM.fetchFavorite(
                    service: FavoritePreviewService(client: appVM.client),
                    friendVM: friendVM
                )
            } catch {
                appVM.handleError(error)
            }
        }
}
