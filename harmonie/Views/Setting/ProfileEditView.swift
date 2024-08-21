//
//  ProfileEditView.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/21.
//

import SwiftUI
import VRCKit

struct ProfileEditView: View {
    @State var status: UserStatus

    init(user: User) {
        _status = State(initialValue: user.status)
    }

    var body: some View {
        NavigationStack {
            Form {
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
            }
            .toolbar { toolbarContents }
        }
    }

    @ToolbarContentBuilder var toolbarContents: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                print("Saving!")
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
