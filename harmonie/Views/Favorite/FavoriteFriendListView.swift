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

    init(selected: Binding<Selected?>) {
        _selected = selected
    }

    var body: some View {
        let groups = favoriteVM.favoriteGroups(.friend)
        List(groups, selection: $selected) { group in
            if let friends = favoriteVM.getFavoriteFriends(group.id) {
                DisclosureGroup(group.displayName) {
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
                }
            } else {
                Text("\(group.displayName) (Empty)")
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
}

#Preview {
    @Previewable @State var selected: Selected?
    PreviewContainer {
        FavoriteFriendListView(selected: $selected)
    }
}
