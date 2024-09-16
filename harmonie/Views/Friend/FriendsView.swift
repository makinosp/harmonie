//
//  FriendsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct FriendsView: View, FriendServicePresentable {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel
    @State private var selected: String?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        @Bindable var friendVM = friendVM
        NavigationSplitView(columnVisibility: $columnVisibility) {
            FriendsListView(selected: $selected)
                .overlay { overlayView }
                .toolbar { toolbarContent }
                .navigationTitle("Friends")
                .refreshable {
                    await refreshAction()
                }
        } detail: {
            if let selected = selected {
                UserDetailPresentationView(id: selected).id(selected)
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
        .searchable(text: $friendVM.filterText)
        .onSubmit(of: .search) {
            friendVM.applyFilters()
        }
        .navigationSplitViewStyle(.balanced)
        .onChange(of: friendVM.favoriteFriends) { _, favoriteFriends in
            friendVM.setFavoriteFriends(favoriteFriends: favoriteFriends)
        }
        .onAppear {
            friendVM.clearFilters()
        }
    }

    private func refreshAction() async {
        do {
            try await friendVM.fetchAllFriends(service: friendService)
        } catch {
            appVM.handleError(error)
        }
    }

    @ViewBuilder private var overlayView: some View {
        if friendVM.isProcessingFilter {
            ProgressView()
        } else if friendVM.filterResultFriends.isEmpty {
            if friendVM.isEmptyAllFilters {
                ContentUnavailableView {
                    Label {
                        Text("No Friends")
                    } icon: {
                        Constants.Icon.friends
                    }
                }
            } else {
                ContentUnavailableView.search
            }
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
