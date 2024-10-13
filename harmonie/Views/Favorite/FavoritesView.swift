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
    @State private var selected: SegmentIdSelection?
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
            .overlay {
                if favoriteVM.isSelectedEmpty {
                    ContentUnavailableView {
                        Label("No Favorites", systemImage: IconSet.favorite.systemName)
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
            .contentMargins(.top, 8)
            .navigationTitle(favoriteVM.segment.description)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarTitleMenu { toolbarTitleMenu }
        } detail: { detail }
        .navigationSplitViewStyle(.balanced)
    }

    @ViewBuilder private var toolbarTitleMenu: some View {
        @Bindable var favoriteVM = favoriteVM
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

    @ViewBuilder private var detail: some View {
        if let selectedContainer = selected {
            switch selectedContainer.segment {
            case .friends:
                UserDetailPresentationView(id: selectedContainer.selected.id)
            case .world:
                WorldPresentationView(id: selectedContainer.selected.id)
            default:
                EmptyView()
            }
        } else {
            ContentUnavailableView {
                Label {
                    Text("Select an item")
                } icon: {
                    IconSet.favorite.icon
                }
            }
        }
    }

    var favoriteFriends: some View {
        Section("Friends") {
            let groups = favoriteVM.favoriteGroups(.friend)
            ForEach(groups) { group in
                if let friends = favoriteVM.getFavoriteFriends(group.id) {
                    friendsDisclosureGroup(group.displayName, friends: friends)
                } else {
                    groupLabel(group.displayName, count: .zero, max: .friends)
                }
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

    var favoriteWorlds: some View {
        Section("World") {
            ForEach(favoriteVM.favoriteWorldGroups) { favoriteWorlds in
                if let group = favoriteWorlds.group {
                    worldDisclosureGroup(group.displayName, favoriteWorlds: favoriteWorlds)
                }
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
