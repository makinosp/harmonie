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
        NavigationSplitView(columnVisibility: .constant(.all)) {
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
                .navigationDestination(item: $selected) { selected in
                    UserDetailPresentationView(id: selected.id)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Picker("", selection: $favoriteVM.segment) {
                            ForEach(FavoriteViewModel.Segment.allCases) { segment in
                                Text(segment.description).tag(segment)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                .navigationTitle("Favorites")
            } else {
                ProgressScreen()
                    .navigationTitle("Favorites")
            }
        } detail: {
            Text("Select a friend")
        }
        .navigationSplitViewStyle(.balanced)
    }

    func rowView(_ friend: Friend) -> some View {
        Button {
            selected = Selected(id: friend.id)
        } label: {
            HStack {
                CircleURLImage(
                    imageUrl: friend.thumbnailUrl,
                    size: Constants.IconSize.thumbnail
                )
                Text(friend.displayName)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(uiColor: .systemGray))
                    .imageScale(.small)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
    }
}
