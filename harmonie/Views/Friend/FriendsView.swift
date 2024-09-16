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
    @State var selected: String?

    var body: some View {
        NavigationSplitView {
            listView
                // .overlay { contentUnavailableView }
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
        .navigationSplitViewStyle(.balanced)
    }

    private func refreshAction() async {
        do {
            try await friendVM.fetchAllFriends(service: friendService)
        } catch {
            appVM.handleError(error)
        }
    }

//    @ViewBuilder private var contentUnavailableView: some View {
//        if filteredFriends.isEmpty {
//            if friendVM.isEmptyAllFilters {
//                ContentUnavailableView {
//                    Label {
//                        Text("No Friends")
//                    } icon: {
//                        Constants.Icon.friends
//                    }
//                }
//            } else {
//                ContentUnavailableView.search
//            }
//        }
//    }

    @ToolbarContentBuilder var toolbarContent: some ToolbarContent {
        ToolbarItem { sortMenu }
        ToolbarItem { filterMenu }
    }

    /// Friend List branched by list type
    var listView: some View {
        // TODO: Replace filtered friends list
        List(friendVM.filteredFriends, id: \.id, selection: $selected) { friend in
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
