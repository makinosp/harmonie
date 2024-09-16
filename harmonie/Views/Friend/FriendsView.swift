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
    @State var selected: Selected?

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            listView
                .navigationSplitViewStyle(.balanced)
                .overlay { contentUnavailableView }
                .toolbar { toolbarContent }
                .navigationTitle("Friends")
                .navigationDestination(item: $selected) { selected in
                    UserDetailPresentationView(id: selected.id)
                        .id(selected.id)
                }
                .refreshable {
                    await refreshAction()
                }
        } detail: {
            Text("Select a friend")
        }
    }

    private func refreshAction() async {
        do {
            try await friendVM.fetchAllFriends(service: friendService)
        } catch {
            appVM.handleError(error)
        }
    }

    @ViewBuilder private var contentUnavailableView: some View {
        if filteredFriends.isEmpty {
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

    @ToolbarContentBuilder var toolbarContent: some ToolbarContent {
        ToolbarItem { sortMenu }
        ToolbarItem { filterMenu }
    }

    /// Friend List branched by list type
    var listView: some View {
        List(filteredFriends) { friend in
            Button {
                selected = Selected(id: friend.id)
            } label: {
                LabeledContent {
                    Constants.Icon.forward
                } label: {
                    Label {
                        Text(friend.displayName)
                    } icon: {
                        ZStack {
                            Circle()
                                .foregroundStyle(friend.status.color)
                                .frame(size: Constants.IconSize.thumbnailOutside)
                            CircleURLImage(
                                imageUrl: friend.imageUrl(.x256),
                                size: Constants.IconSize.thumbnail
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
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
