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
            List(selection: $selected) {
                if favoriteVM.segment != .world {
                    favoriteFriends
                }
                if favoriteVM.segment != .friends {
                    favoriteWorlds
                }
            }
            .contentMargins(.top, 8)
            .navigationTitle(favoriteVM.segment.description)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarTitleMenu {
                Picker("", selection: $favoriteVM.segment) {
                    ForEach(FavoriteViewSegment.allCases) { segment in
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
//            if let selected = selected {
//                switch favoriteVM.segment {
//                case .friends:
//                    UserDetailPresentationView(id: selected.id)
//                case .world:
//                    WorldPresentationView(id: selected.id)
//                }
//            } else {
//                ContentUnavailableView {
//                    Label {
//                        Text("Select an item")
//                    } icon: {
//                        IconSet.favorite.icon
//                    }
//                }
//            }
        }
        .navigationSplitViewStyle(.balanced)
    }

    @ViewBuilder
    var favoriteFriends: some View {
        let groups = favoriteVM.favoriteGroups(.friend)
        ForEach(groups) { group in
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

    var favoriteWorlds: some View {
        ForEach(favoriteVM.favoriteWorldGroups) { favoriteWorlds in
            if let group = favoriteWorlds.group {
                worldDisclosureGroup(group.displayName, favoriteWorlds: favoriteWorlds)
            }
        }
        .overlay {
            if favoriteVM.favoriteWorlds.isEmpty {
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

    private func worldDisclosureGroup(
        _ title: any StringProtocol,
        favoriteWorlds: FavoriteWorldGroup
    ) -> DisclosureGroup<some View, some View> {
        DisclosureGroup {
            ForEach(favoriteWorlds.worlds) { world in
                worldItem(world)
                    .tag(Selected(id: world.id))
            }
        } label: {
            groupLabel(title, count: favoriteWorlds.worlds.count, max: .world)
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

    private func worldItem(_ world: FavoriteWorld) -> some View {
        HStack(spacing: 12) {
            SquareURLImage(
                imageUrl: world.imageUrl(.x512),
                thumbnailImageUrl: world.imageUrl(.x256)
            )
            VStack(alignment: .leading) {
                Text(world.name)
                    .font(.body)
                    .lineLimit(1)
                Text(world.description ?? "")
                    .font(.footnote)
                    .foregroundStyle(Color.gray)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            IconSet.forward.icon
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
    PreviewContainer {
        FavoritesView()
    }
}
