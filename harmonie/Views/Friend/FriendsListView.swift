//
//  FriendsListView.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/16.
//

import SwiftUI

struct FriendsListView: View {
    @Environment(\.isSearching) private var isSearching
    @Environment(FriendViewModel.self) var friendVM: FriendViewModel
    @Binding private var selected: String?

    init(selected: Binding<String?>) {
        _selected = selected
    }

    var body: some View {
        List(friendVM.filterResultFriends, selection: $selected) { friend in
            Label {
                LabeledContent {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        Constants.Icon.forward
                    }
                } label: {
                    Text(friend.displayName)
                }
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
        .onChange(of: isSearching) {
            if !isSearching {
                friendVM.filterText = ""
                friendVM.applyFilters()
            }
        }
    }
}
