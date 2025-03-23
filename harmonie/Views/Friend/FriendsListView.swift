//
//  FriendsListView.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/16.
//

import AsyncSwiftUI
import MemberwiseInit
import VRCKit

@MemberwiseInit
struct FriendsListView: View {
    @Environment(\.isSearching) private var isSearching
    @Environment(AppViewModel.self) var appVM
    @Environment(FriendViewModel.self) var friendVM
    @Environment(FavoriteViewModel.self) var favoriteVM
    @InitWrapper(.internal, type: Binding<String?>)
    @Binding private var selected: String?
    @State var isPresentedSheet = false
    @State private var swipeActions = SwipeActions()

    var body: some View {
        List(friendVM.filterResultFriends, selection: $selected) { friend in
            Label {
                NavigationLabel {
                    Text(friend.displayName)
                }
            } icon: {
                UserIcon(user: friend, size: Constants.IconSize.thumbnail)
            }
            .swipeActions(edge: .leading) {
                swipeActionViewBuilder(friend: friend, keypath: \.leading)
            }
            .swipeActions(edge: .trailing) {
                swipeActionViewBuilder(friend: friend, keypath: \.trailing)
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

    private func favoriteMenuItem(friendId: Friend.ID, group: FavoriteGroup) -> some View {
        AsyncButton {
//            await updateFavoriteAction(friendId: friendId, group: group)
        } label: {
            Label {
                Text(group.displayName)
            } icon: {
                if favoriteVM.isInFavoriteGroup(
                    friendId: friendId,
                    groupId: group.id
                ) {
                    IconSet.check.icon
                }
            }
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

    @ViewBuilder
    private func swipeActionViewBuilder(friend: Friend, keypath: KeyPath<SwipeActions, [SwipeActionType]>) -> some View {
        let actions = swipeActions[keyPath: keypath]
        ForEach(actions) { swipeActionType in
            switch swipeActionType {
            case .delete:
                swipeActionDelete(id: friend.id)
            case .favorite:
                swipeActionFavorite(friend: friend)
            }
        }
    }

    private func swipeActionDelete(id: Friend.ID) -> some View {
        Button(role: .destructive) {
            print("delete action.")
        } label: {
            IconSet.unfriend.icon
        }
    }

    private func swipeActionFavorite(friend: Friend) -> some View {
        Menu {
            ForEach(favoriteVM.favoriteGroups(.friend)) { group in
                favoriteMenuItem(friendId: friend.id, group: group)
            }
        } label: {
            if favoriteVM.isAdded(friendId: friend.id) {
                IconSet.favoriteFilled.icon
            } else {
                IconSet.favorite.icon
            }
        }
        .tint(.yellow)
    }
}
