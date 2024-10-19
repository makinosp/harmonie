//
//  HelpView.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/19.
//

import MemberwiseInit
import SwiftUI

@MemberwiseInit
struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    @Init(.internal) private let title: LocalizedStringKey
    @Init(.internal) private let contents: [Constants.Messages]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    ForEach(contents, id: \.hashValue) { content($0) }
                }
                .foregroundStyle(Color(.systemGray))
                .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func content(_ message: Constants.Messages) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(message.title)
                .font(.headline)
            Text(message.text)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
