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

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            listView
        } detail: {
            Text("Select a friend")
        }
        .navigationSplitViewStyle(.balanced)
    }

    var listView: some View {
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
    }

    func rowView(_ friend: Friend) -> some View {
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
                            imageUrl: friend.thumbnailUrl,
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
