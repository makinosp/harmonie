//
//  NavigationLabel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/22.
//

import SwiftUI

@MainActor
struct NavigationLabel<Label> where Label: View {
    private let label: () -> Label

    init(label: @escaping () -> Label) {
        self.label = label
    }

    @ViewBuilder
    func content() -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad {
            IconSet.forward.icon
                .foregroundStyle(Color(.tertiaryLabel))
                .imageScale(.small)
                .unredacted()
        }
    }
}

extension NavigationLabel where Label == EmptyView {
    init() {
        label = { EmptyView() }
    }
}

extension NavigationLabel: View {
    var body: some View {
        LabeledContent(content: content, label: label)
    }
}

extension NavigationLabel where Label == EmptyView {
    var body: some View {
        content()
    }
}
