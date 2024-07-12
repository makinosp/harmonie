//
//  FavoritesView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/16.
//

import VRCKit
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    @State var friendSelection: Friend?
    @State var isFetching = false

    let thumbnailSize = CGSize(width: 32, height: 32)

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
                .sheet(item: $friendSelection) { friend in
                    UserDetailView(id: friend.id)
                        .presentationDetents([.medium, .large])
                        .presentationBackground(Color(UIColor.systemGroupedBackground))
                }
                .navigationTitle("Favorites")
            } else {
                ProgressScreen()
                    .navigationTitle("Favorites")
            }
        } detail: { EmptyView() }
    }

    func rowView(_ friend: Friend) -> some View {
        HStack {
            CircleURLImage(
                imageUrl: friend.userIconUrl,
                size: thumbnailSize
            )
            Text(friend.displayName)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            friendSelection = friend
        }
    }
}
