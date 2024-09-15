//
//  FavoriteWorldListView.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/15.
//

import SwiftUI
import VRCKit

struct FavoriteWorldListView: View {
    @Environment(FavoriteViewModel.self) var favoriteVM: FavoriteViewModel
    @State private var selected: Selected?

    var body: some View {
        List {
            ForEach(groupedWorlds.keys.sorted(), id: \.self) { group in
                if let worlds = groupedWorlds[group] {
                    Section(header: Text(group)) {
                        ForEach(worlds) { world in
                            worldItem(world)
                        }
                    }
                }
            }
        }
        .navigationDestination(item: $selected) { selected in
            WorldDetailPresentationView(id: selected.id)
        }
    }

    private var groupedWorlds: [String: [World]] {
        Dictionary(grouping: favoriteVM.favoriteWorlds, by: { $0.favoriteGroup ?? "Unknown" })
    }

    private func worldItem(_ world: World) -> some View {
        Button {
            selected = Selected(id: world.id)
        } label: {
            HStack(spacing: 16) {
                SquareURLImage(
                    imageUrl: world.imageUrl(.x512),
                    thumbnailImageUrl: world.imageUrl(.x256)
                )
                HStack {
                    VStack(alignment: .leading) {
                        Text(world.name)
                            .font(.body)
                            .lineLimit(1)
                        HStack {
                            Text("author: ")
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                            Text(world.authorName)
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Constants.Icon.forward
                }
            }
        }
        .contentShape(Rectangle())
    }
}
