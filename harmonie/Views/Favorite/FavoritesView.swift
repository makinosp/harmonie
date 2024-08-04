//
//  FavoritesView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct FavoritesView: View {
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    @State var selected: Selected?
    @State var isFetching = false

    var body: some View {
        NavigationSplitView {
            if !isFetching {
                List {
                    ForEach(favoriteVM.favoriteFriendGroups) { group in
                        if let friends = favoriteVM.getFavoriteFriends(group.id) {
                            Section(header: Text(group.displayName)) {
                                ForEach(friends) { friend in
                                    rowView(friend)
                                }
                            }
                        }
                    }
                }
                .sheet(item: $selected) { selected in
                    UserDetailPresentationView(id: selected.id)
                        .presentationDetents([.medium, .large])
                        .presentationBackground(Color(UIColor.systemGroupedBackground))
                }
                .navigationTitle("Favorites")
            } else {
                ProgressScreen()
                    .navigationTitle("Favorites")
            }
        } detail: {
            EmptyView()
        }
    }

    func rowView(_ friend: Friend) -> some View {
        HStack {
            CircleURLImage(
                imageUrl: friend.userIconUrl,
                size: Constants.IconSize.thumbnail
            )
            Text(friend.displayName)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            selected = Selected(id: friend.id)
        }
    }
}
