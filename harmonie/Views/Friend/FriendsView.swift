//
//  FriendsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct FriendsView: View {
    @Environment(FriendViewModel.self) var friendVM
    @Environment(FavoriteViewModel.self) var favoriteVM
    @State private var selected: String?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        @Bindable var friendVM = friendVM
        NavigationSplitView(columnVisibility: $columnVisibility) {
            FriendsListView(selected: $selected)
                .navigationTitle("Friends")
        } detail: { detail }
        .navigationSplitViewStyle(.balanced)
        .searchable(
            text: $friendVM.filterText,
            placement: .navigationBarDrawer(displayMode: .always)
        )
        .onSubmit(of: .search) {
            friendVM.applyFilters()
        }
    }

    private var detail: some View {
        Group {
            if let selected = selected {
                UserDetailPresentationView(id: selected)
                    .id(selected)
            } else {
                ContentUnavailableView {
                    Label {
                        Text("Select a Friend")
                    } icon: {
                        IconSet.friends.icon
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    PreviewContainer {
        FriendsView()
    }
}
