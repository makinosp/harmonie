//
//  FavoriteFriendListView.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/15.
//

import SwiftUI
import VRCKit

struct FavoriteFriendListView: View {
    @Environment(FavoriteViewModel.self) var favoriteVM
    @Binding private var selected: Selected?
    private let maxListCount = 150

    init(selected: Binding<Selected?>) {
        _selected = selected
    }

    var body: some View {
        let groups = favoriteVM.favoriteGroups(.friend)
        List(groups, selection: $selected) { group in
            if let friends = favoriteVM.getFavoriteFriends(group.id) {
                friendsDisclosureGroup(group.displayName, friends: friends)
            } else {
                groupLabel(group.displayName, count: .zero, max: .friends)
            }
        }
        .overlay {
            if groups.isEmpty {
                ContentUnavailableView {
                    Label {
                        Text("No Favorites")
                    } icon: {
                        IconSet.favorite.icon
                    }
                }
                .background(Color(.systemGroupedBackground))
            }
        }
    }

    private func friendsDisclosureGroup(
        _ title: any StringProtocol,
        friends: [Friend]
    ) -> DisclosureGroup<some View, some View> {
        DisclosureGroup {
            ForEach(friends) { friend in
                NavigationLabel {
                    Label {
                        Text(friend.displayName)
                    } icon: {
                        UserIcon(user: friend, size: Constants.IconSize.thumbnail)
                    }
                }
                .tag(Selected(id: friend.id))
            }
        } label: {
            groupLabel(title, count: friends.count, max: .friends)
        }
    }

    private func groupLabel(
        _ title: any StringProtocol,
        count: Int,
        max: Constants.MaxCountInFavoriteList
    ) -> some View {
        LabeledContent {
            Text("\(count.description) / \(max.description)")
        } label: {
            Text(title)
        }
    }
}

#Preview {
    @Previewable @State var selected: Selected?
    PreviewContainer {
        FavoriteFriendListView(selected: $selected)
    }
}
