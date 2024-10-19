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
    @Binding private var inputtedURL: URL?
    @State private var urlString: String
    @State private var isInvalid = false

    init(inputtedURL: Binding<URL?>, urlString: String = "") {
        _inputtedURL = inputtedURL
        _urlString = State(initialValue: urlString)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("https://", text: $urlString)
                    .textInputAutocapitalization(.never)
                    .onChange(of: urlString, initial: true) {
                        isInvalid = !urlString.isValidURLFormat
                    }
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
                inputtedURL = URL(string: urlString)
                dismiss()
            } label: {
                Text("Confirm")
            }
            .disabled(isInvalid)
        }
    }
}

fileprivate extension String {
    @MainActor var isValidURLFormat: Bool {
        if let url = URL(string: self), UIApplication.shared.canOpenURL(url) { true } else { false }
    }
}

#Preview("URLEditorView") {
    @Previewable @State var inputtedURL: URL?
    return URLEditorView(inputtedURL: $inputtedURL)
}
