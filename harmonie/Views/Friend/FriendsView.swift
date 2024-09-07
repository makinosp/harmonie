//
//  FriendsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct FriendsView: View {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel
    @State var selected: Selected?

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            listView
        } detail: {
            Text("Select a friend")
        }
        .refreshable {
            do {
                try await friendVM.fetchAllFriends()
            } catch {
                appVM.handleError(error)
            }
        }
        .navigationSplitViewStyle(.balanced)
    }

    var bindFilterText: Binding<String> {
        @Bindable var friendVM = friendVM
        return $friendVM.filterText
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
        .overlay {
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
        .navigationTitle("Friends")
        .searchable(text: bindFilterText)
        .toolbar { toolbarContent }
        .navigationDestination(item: $selected) { selected in
            UserDetailPresentationView(id: selected.id)
                .id(selected.id)
        }
    }
}

#Preview {
    let appVM = AppViewModel()
    let friendVM = FriendViewModel(
        user: PreviewDataProvider.shared.previewUser,
        service: FriendPreviewService(client: appVM.client)
    )
    let favoriteVM = FavoriteViewModel(
        service: FavoritePreviewService(client: appVM.client)
    )
    FriendsView()
        .task {
            do {
                try await friendVM.fetchAllFriends()
                try await favoriteVM.fetchFavorite(friendVM: friendVM)
            } catch {
                appVM.handleError(error)
            }
        }
        .environment(friendVM)
        .environment(favoriteVM)
}
