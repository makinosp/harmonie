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
        List(favoriteVM.groupedFavoriteWorlds, selection: $selected) { favoriteWorlds in
            if let group = favoriteWorlds.group {
                DisclosureGroup(group.displayName) {
                    ForEach(favoriteWorlds.worlds) { world in
                        worldItem(world)
                            .tag(Selected(id: world.id))
                    }
                }
            }
        }
        .overlay {
            if favoriteVM.favoriteWorlds.isEmpty {
                ContentUnavailableView {
                    Label {
                        Text("No Favorites")
                    } icon: {
                        Constants.IconSet.favorite.icon
                    }
                }
                .background(Color(.systemGroupedBackground))
            }
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
            Constants.IconSet.forward.icon
        }
    }
}
