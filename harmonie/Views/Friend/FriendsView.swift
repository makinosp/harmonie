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
    @State private var searchText = ""
    @State var selected: Selected?

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            listView
        } detail: {
            Text("Select a friend")
        }
        .refreshable {
            do {
                try await friendVM.fetchAllFriends(service: friendService)
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
        .toolbar { toolbarContent }
        .navigationDestination(item: $selected) { selected in
            UserDetailPresentationView(id: selected.id)
                .id(selected.id)
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search) {
            friendVM.filterText = searchText
        }
    }
}

#Preview {
    let appVM = AppViewModel()
    let friendVM = FriendViewModel(
        user: PreviewDataProvider.shared.previewUser
    )
    let favoriteVM = FavoriteViewModel(
        service: FavoritePreviewService(client: appVM.client)
    )
    FriendsView()
        .task {
            do {
                try await friendVM.fetchAllFriends(service: FriendPreviewService(client: appVM.client))
                try await favoriteVM.fetchFavorite(friendVM: friendVM)
            } catch {
                appVM.handleError(error)
            }
        }
        .environment(friendVM)
        .environment(favoriteVM)
}
