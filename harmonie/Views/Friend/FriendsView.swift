//
//  FriendsView.swift
//  Harmonie
//
//  Created by makinosp on 2024/03/03.
//

import SwiftUI
import VRCKit

struct FriendsView: View {
    @EnvironmentObject var friendVM: FriendViewModel
    @State var typeFilters: Set<UserStatus> = []
    @State var friendSelection: Friend?
    @State var searchString: String = ""

    var body: some View {
        NavigationStack {
            listView
                .navigationTitle("Friends")
                .searchable(text: $searchString)
                .toolbar { toolbarContent }
        }
        .sheet(item: $friendSelection) { friend in
            UserDetailView(id: friend.id)
                .presentationDetents([.medium, .large])
                .presentationBackground(Color(UIColor.systemGroupedBackground))
        }
    }

    var toolbarContent: some ToolbarContent {
        ToolbarItem {
            Menu {
                statusFilter
            } label: {
                Image(systemName: Constants.IconName.filter)
            }
        }
    }

    var statusFilter: some View {
        Menu("Statuses") {
            ForEach(FriendViewModel.FriendListType.allCases) { listType in
                Button {
                    statusFilterAction(listType)
                } label: {
                    Label {
                        Text(listType.description)
                    } icon: {
                        if isCheckedStatusFilter(listType) {
                            Image(systemName: Constants.IconName.check)
                        }
                    }
                }
            }
        }
    }

    func statusFilterAction(_ listType: FriendViewModel.FriendListType) {
        switch listType {
        case .all:
            typeFilters.removeAll()
        case .status(let status):
            if typeFilters.contains(status) {
                typeFilters.remove(status)
            } else {
                typeFilters.insert(status)
            }
        }
    }

    func isCheckedStatusFilter(_ listType: FriendViewModel.FriendListType) -> Bool {
        switch listType {
        case .all:
            typeFilters.isEmpty
        case .status(let status):
            typeFilters.contains(status)
        }
    }

    /// Friend List branched by list type
    var listView: some View {
        List {
            ForEach(friendVM.filterFriends(text: searchString, statuses: typeFilters)) { friend in
                HStack {
                    ZStack {
                        Circle()
                            .foregroundStyle(friend.status.color)
                            .frame(size: Constants.IconSize.thumbnailOutside)
                        CircleURLImage(
                            imageUrl: friend.userIconUrl,
                            size: Constants.IconSize.thumbnail
                        )
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
        .listStyle(.inset)
    }
}

extension FriendViewModel.FriendListType: CaseIterable {
    static var allCases: [FriendViewModel.FriendListType] {
        [
            .all,
            .status(.active),
            .status(.joinMe),
            .status(.askMe),
            .status(.busy),
            .status(.offline),
        ]
    }
}
