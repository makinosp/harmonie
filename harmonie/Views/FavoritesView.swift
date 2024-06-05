//
//  FavoritesView.swift
//  harmonie
//
//  Created by makinosp on 2024/03/16.
//

import VRCKit
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var userData: UserData
    @State var friendSelection: UserDetail?

    let thumbnailFrame = CGSize(width: 32, height: 32)

    var body: some View {
        NavigationSplitView {
            if let favoriteFriendGroups = userData.favoriteFriendGroups,
               userData.favoriteFriendDetails != nil {
                List {
                    ForEach(favoriteFriendGroups) { group in
                        if let friends = userData.lookUpFavoriteFriends(group.id) {
                            Section(header: Text(group.displayName)) {
                                ForEach(friends) { friend in
                                    rowView(friend)
                                }
                            }
                        }
                    }
                }
                .sheet(item: $friendSelection) { friend in
                    FriendDetailView(friend: friend)
                        .presentationDetents([.medium, .large])
                        .presentationBackground(Color(UIColor.systemGroupedBackground))
                }
                .navigationTitle("Favorites")
            } else {
                HAProgressView()
                    .navigationTitle("Favorites")
            }
        } detail: { EmptyView() }
    }

    func rowView(_ friend: UserDetail) -> some View {
        HStack {
            let imageUrl = friend.userIcon.isEmpty ? friend.currentAvatarThumbnailImageUrl : friend.userIcon
            AsyncImage(
                url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(size: thumbnailFrame)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(size: thumbnailFrame)
                }
            Text(friend.displayName)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            friendSelection = friend
        }
    }
}
