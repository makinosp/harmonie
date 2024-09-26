//
//  FavoriteFriendListView.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/15.
//

import SwiftUI
import VRCKit

struct FavoriteFriendListView: View {
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel
    @Binding private var selected: Selected?

    init(selected: Binding<Selected?>) {
        _selected = selected
    }

    var body: some View {
        List(favoriteVM.favoriteFriendGroups, selection: $selected) { group in
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
            if favoriteVM.favoriteFriendGroups.isEmpty {
                ContentUnavailableView {
                    Label {
                        Text("No Favorites")
                    } icon: {
                        Constants.Icon.favorite
                    }
                }
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
