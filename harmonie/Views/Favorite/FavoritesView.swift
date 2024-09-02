//
//  FavoritesView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct FavoritesView: View {
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel
    @State var selected: Selected?

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Group {
                if favoriteVM.segment == .friend {
                    listView
                } else if favoriteVM.segment == .world {
                    Text("Work in progress!")
                }
            }
            .navigationDestination(item: $selected) { selected in
                UserDetailPresentationView(id: selected.id)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    @Bindable var favoriteVM = favoriteVM
                    Picker("", selection: $favoriteVM.segment) {
                        ForEach(FavoriteViewModel.Segment.allCases) { segment in
                            Text(segment.description).tag(segment)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Favorites")
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
