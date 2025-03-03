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
    @State var isPresentedSheet = false

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
        .sheet(isPresented: $isPresentedSheet) {
            FriendsListSheetView()
                .presentationDetents([.medium])
        }
        .overlay { overlayView }
        .toolbar { toolbarContent }
        .refreshable {
            await friendVM.fetchAllFriends { error in
                appVM.handleError(error)
            }
        }
        .onChange(of: isSearching) {
            if !isSearching {
                friendVM.filterText = ""
                friendVM.applyFilters()
            }
        }
        .onChange(of: friendVM.sortType) {
            friendVM.applyFilters()
        }
        .onChange(of: friendVM.filterUserStatus) {
            friendVM.applyFilters()
        }
        .onChange(of: friendVM.filterFavoriteGroups) {
            friendVM.applyFilters()
        }
    }

    @ViewBuilder private var overlayView: some View {
        if isProcessing {
            ProgressView()
                .padding(32)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
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

    private var isProcessing: Bool {
        friendVM.isProcessingFilter || friendVM.isFetchingAllFriends
    }
}
