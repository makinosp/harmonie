//
//  FriendsListSheetView.swift
//  Harmonie
//
//  Created by makinosp on 2025/01/22.
//

import SwiftUI

struct FriendsListSheetView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        Text("X")
                        Text("X")
                        Text("X")
                        Text("X")
                        Text("X")
                        Text("X")
                        Text("X")
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        ExitButton()
                    }
                }
            }
        }
    }
}
