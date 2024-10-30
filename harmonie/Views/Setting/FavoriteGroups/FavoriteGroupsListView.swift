//
//  FavoriteGroupsListView.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/04.
//

import SwiftUI
import VRCKit

struct FavoriteGroupsListView: View {
    @Environment(FavoriteViewModel.self) var favoriteVM
    @State private var selected: FavoriteGroup?

    var body: some View {
        List {
            let types: [FavoriteType] = [.friend, .world]
            ForEach(types, id: \.hashValue) { type in
                Section(type.localizedStringKey) {
                    ForEach(favoriteVM.favoriteGroups(type)) { group in
                        Button {
                            selected = group
                        } label: {
                            Text(group.displayName)
                                .foregroundStyle(Color(.label))
                        }
                    }
                }
            }
        }
        .sheet(item: $selected) { group in
            FavoriteGroupsEditView(favoriteGroup: group)
                .presentationDetents([.small])
        }
        .navigationTitle("Edit favorite groups")
        .navigationBarTitleDisplayMode(.inline)
    }
}
