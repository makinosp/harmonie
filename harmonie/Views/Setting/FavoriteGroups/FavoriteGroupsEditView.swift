//
//  FavoriteGroupsEditView.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/04.
//

import SwiftUI
import VRCKit

struct FavoriteGroupsEditView: View {
    @Environment(FavoriteViewModel.self) var favoriteVM

    var body: some View {
        List {
            let types: [FavoriteType] = [.friend, .world]
            ForEach(types, id: \.hashValue) { type in
                Section(type.rawValue) {
                    ForEach(favoriteVM.favoriteGroups(type)) { group in
                        Text(group.displayName)
                    }
                }
            }
        }
        .navigationTitle("Edit favorite groups")
        .navigationBarTitleDisplayMode(.inline)
    }
}
