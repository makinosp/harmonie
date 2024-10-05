//
//  FavoriteGroupsEditView.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/04.
//

import SwiftUI

struct FavoriteGroupsEditView: View {
    @Environment(FavoriteViewModel.self) var favoriteVM

    var body: some View {
        // favoriteVM.favoriteGroups([.friend])
        Text("FavoriteGroupsEditView")
            .navigationTitle("Edit favorite groups")
            .navigationBarTitleDisplayMode(.inline)
    }
}
