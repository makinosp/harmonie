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

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Group {
                if favoriteVM.segment == .friend {
                    FavoriteFriendListView()
                } else if favoriteVM.segment == .world {
                    FavoriteWorldListView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .status) {
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
            ContentUnavailableView {
                Label {
                    Text("Select an item")
                } icon: {
                    Constants.Icon.favorite
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}
