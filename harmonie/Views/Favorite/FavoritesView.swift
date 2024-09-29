//
//  FavoritesView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/16.
//

import SwiftUI
import VRCKit

struct FavoritesView: View {
    @Environment(FavoriteViewModel.self) var favoriteVM
    @State private var selected: Selected?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        @Bindable var favoriteVM = favoriteVM
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Group {
                if favoriteVM.segment == .friend {
                    FavoriteFriendListView(selected: $selected)
                } else if favoriteVM.segment == .world {
                    FavoriteWorldListView(selected: $selected)
                }
            }
            .contentMargins(.top, 8)
            .navigationTitle(favoriteVM.segment.description)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarTitleMenu {
                Picker("", selection: $favoriteVM.segment) {
                    ForEach(Segment.allCases) { segment in
                        Label {
                            Text(segment.description)
                        } icon: {
                            segment.icon
                        }
                        .tag(segment)
                    }
                }
            }
        } detail: {
            if let selected = selected {
                switch favoriteVM.segment {
                case .friend:
                    UserDetailPresentationView(id: selected.id)
                case .world:
                    WorldPresentationView(id: selected.id)
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

#Preview {
    PreviewContainer {
        FavoritesView()
    }
}
