//
//  ProfileEditView.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/21.
//

import SwiftUI
import VRCKit

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State var status: UserStatus
    @State var statusDescription: String
    @State var bio: String

    init(user: User) {
        _status = State(initialValue: user.status)
        _statusDescription = State(initialValue: user.statusDescription)
        _bio = State(initialValue: user.bio ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Status") {
                    Picker(selection: $status) {
                        ForEach(UserStatus.allCases) { status in
                            Text(status.description).tag(status)
                        }
                    } label: {
                        Label {
                            Text("Status")
                        } icon: {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(status.color)
                        }
                    }
                    TextField("Status Description", text: $statusDescription)
                }
                Section("Description") {
                    TextEditor(text: $bio)
                }
            }
            .toolbar { toolbarContents }
        }
    }

    @ToolbarContentBuilder var toolbarContents: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
            }
        }
        ToolbarItem {
            Button {
                print("Saving!")
            } label: {
                Text("Save")
            }
        }
    }
}
