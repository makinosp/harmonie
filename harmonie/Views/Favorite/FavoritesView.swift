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
    @State private var selected: Selected?

    var body: some View {
        @Bindable var favoriteVM = favoriteVM
        NavigationSplitView(columnVisibility: .constant(.all)) {
            VStack {
                Picker("", selection: $favoriteVM.segment) {
                    ForEach(Segment.allCases) { segment in
                        Text(segment.description).tag(segment)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                Group {
                    if favoriteVM.segment == .friend {
                        FavoriteFriendListView(selected: $selected)
                    } else if favoriteVM.segment == .world {
                        FavoriteWorldListView(selected: $selected)
                    }
                }
                .contentMargins(.top, 0)
            }
            .navigationTitle("Favorites")
        } detail: {
            if let selected = selected {
                switch favoriteVM.segment {
                case .friend:
                    UserDetailPresentationView(id: selected.id)
                case .world:
                    WorldDetailPresentationView(id: selected.id)
                }
            } else {
                ContentUnavailableView {
                    Label {
                        Text("Select an item")
                    } icon: {
                        Constants.Icon.favorite
                    }
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}
