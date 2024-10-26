//
//  FriendsListView.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/16.
//

import MemberwiseInit
import SwiftUI

@MemberwiseInit
struct FriendsListView: View {
    @Environment(\.isSearching) private var isSearching
    @Environment(AppViewModel.self) var appVM
    @Environment(FriendViewModel.self) var friendVM
    @Environment(FavoriteViewModel.self) var favoriteVM
    @InitWrapper(.internal, type: Binding<String?>)
    @Binding private var selected: String?

    var body: some View {
        List(friendVM.filterResultFriends, selection: $selected) { friend in
            Label {
                NavigationLabel {
                    Text(friend.displayName)
                }
            } icon: {
                UserIcon(user: friend, size: Constants.IconSize.thumbnail)
            }
        }
        .overlay { overlayView }
        .toolbar { toolbarContent }
        .refreshable {
            await refreshAction()
        }
        .onChange(of: isSearching) {
            if !isSearching {
                friendVM.filterText = ""
                friendVM.applyFilters()
            }
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
                        IconSet.friends.icon
                    }
                }
            } else {
                ContentUnavailableView.search
            }
        }
    }

    private func refreshAction() async {
        do {
            try await friendVM.fetchAllFriends()
        } catch {
            appVM.handleError(error)
        }
    }
}
