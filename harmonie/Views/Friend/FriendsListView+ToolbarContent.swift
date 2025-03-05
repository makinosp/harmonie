//
//  FriendsListView+ToolbarContent.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/12.
//

import SwiftUI
import VRCKit

extension FriendsListView {
    @ToolbarContentBuilder var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) { presentSheetButton }
    }

    private var presentSheetButton: some View {
        Button("", systemImage: IconSet.dots.systemName) {
            isPresentedSheet.toggle()
        }
    }
}
