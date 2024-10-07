//
//  FavoriteGroupsEditView.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/04.
//

import AsyncSwiftUI
import VRCKit

struct FavoriteGroupsEditView: View {
    @Environment(FavoriteViewModel.self) var favoriteVM
    @State private var selected: FavoriteGroup?

    var body: some View {
        List {
            let types: [FavoriteType] = [.friend, .world]
            ForEach(types, id: \.hashValue) { type in
                Section(type.rawValue) {
                    ForEach(favoriteVM.favoriteGroups(type)) { group in
                        Button {
                            selected = group
                        } label: {
                            Text(group.displayName)
                        }
                    }
                }
            }
        }
        .sheet(item: $selected) { group in
            TextFormView(favoriteGroup: group)
        }
        .navigationTitle("Edit favorite groups")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TextFormView: View, FavoriteServicePresentable {
    @Environment(AppViewModel.self) var appVM
    @Environment(FavoriteViewModel.self) var favoriteVM
    @Environment(\.dismiss) private var dismiss
    @State private var displayName: String
    @State private var visibility: FavoriteGroup.Visibility
    @State private var isRequesting = false
    let favoriteGroup: FavoriteGroup

    init(favoriteGroup: FavoriteGroup) {
        self.favoriteGroup = favoriteGroup
        _displayName = State(initialValue: favoriteGroup.displayName)
        _visibility = State(initialValue: favoriteGroup.visibility)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Display Name") {
                    TextField("", text: $displayName)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    AsyncButton {
                        await saveAction()
                    } label: {
                        if isRequesting {
                            Text("Save")
                        } else {
                            ProgressView()
                        }
                    }
                }
            }
        }
    }

    func saveAction() async {
        defer { isRequesting = false }
        isRequesting = true
        do {
            _ = try await favoriteVM.updateFavoriteGroup(
                service: favoriteService,
                id: favoriteGroup.id,
                displayName: displayName,
                visibility: visibility
            )
            dismiss()
        } catch {
            appVM.handleError(error)
        }
    }
}
