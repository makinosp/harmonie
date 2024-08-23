//
//  URLEditorView.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/23.
//

import SwiftUI
import VRCKit

struct URLEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding private var inputtedURL: String

    init(inputtedURL: Binding<String>) {
        _inputtedURL = inputtedURL
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("https://", text: $inputtedURL)
            }
            .navigationTitle("Enter URL")
            .toolbarTitleDisplayMode(.inline)
            .toolbar { toolbarContents }
        }
    }

    @ToolbarContentBuilder private var toolbarContents: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
            }
        }
        ToolbarItem {
            Button {
                dismiss()
            } label: {
                Text("Confirm")
            }
        }
    }
}

#Preview {
    @State var inputtedURL: String = ""
    return URLEditorView(inputtedURL: $inputtedURL)
}
