//
//  FavoriteGroupsEditView.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/07.
//

import AsyncSwiftUI
import VRCKit

struct FavoriteGroupsEditView: View, FavoriteServiceRepresentable {
    @Environment(AppViewModel.self) var appVM
    @Environment(FavoriteViewModel.self) var favoriteVM
    @Environment(\.dismiss) private var dismiss
    @State private var displayName: String
    @State private var visibility: FavoriteGroup.Visibility
    @State private var isRequesting = false
    private let favoriteGroup: FavoriteGroup

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
            .toolbar { toolbarItems }
        }
    }

    @ToolbarContentBuilder var toolbarItems: some ToolbarContent {
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
                    ProgressView()
                } else {
                    Text("Save")
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
