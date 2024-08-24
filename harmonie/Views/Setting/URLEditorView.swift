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
    @State private var urlString: String
    @State private var isInvalid = false

    init(inputtedURL: Binding<String>) {
        _inputtedURL = inputtedURL
        _urlString = State(initialValue: inputtedURL.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("https://", text: $urlString)
                    .textInputAutocapitalization(.never)
                    .onChange(of: urlString, initial: true) {
                        isInvalid = !isValidURLFormat(urlString)
                    }
            }
            .navigationTitle("Enter URL")
            .toolbarTitleDisplayMode(.inline)
            .toolbar { toolbarContents }
        }
    }

    private func isValidURLFormat(_ string: String) -> Bool {
        if let url = URL(string: string), UIApplication.shared.canOpenURL(url) {
            return true
        } else {
            return false
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
                inputtedURL = urlString
                dismiss()
            } label: {
                Text("Confirm")
            }
            .disabled(isInvalid)
        }
    }
}

#Preview {
    @State var inputtedURL: String = ""
    return URLEditorView(inputtedURL: $inputtedURL)
}
