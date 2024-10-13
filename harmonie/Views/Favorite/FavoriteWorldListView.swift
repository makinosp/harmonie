//
//  FavoriteWorldListView.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/15.
//

import SwiftUI
import VRCKit

struct FavoriteWorldListView: View {
    @Environment(FavoriteViewModel.self) var favoriteVM
    @Binding private var selected: Selected?

    init(selected: Binding<Selected?>) {
        _selected = selected
    }

    var body: some View {
        List(favoriteVM.favoriteWorldGroups, selection: $selected) { favoriteWorlds in
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
}
