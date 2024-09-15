//
//  FavoriteFriendListView.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/15.
//

import SwiftUI
import VRCKit

struct FavoriteFriendListView: View {
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel
    @State private var selected: Selected?

    var body: some View {
        List {
            ForEach(favoriteVM.favoriteFriendGroups) { group in
                if let friends = favoriteVM.getFavoriteFriends(group.id) {
                    Section(header: Text(group.displayName)) {
                        ForEach(friends) { friend in
                            friendItem(friend)
                        }
                    }
                }
            }
        }
        .navigationDestination(item: $selected) { selected in
            UserDetailPresentationView(id: selected.id)
        }
        .overlay {
            if favoriteVM.favoriteFriendGroups.isEmpty {
                ContentUnavailableView {
                    Label {
                        Text("No Favorites")
                    } icon: {
                        Constants.Icon.favorite
                    }
                }
            }
        }
    }

    private func friendItem(_ friend: Friend) -> some View {
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
