//
//  NavigationLabel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/22.
//

import MemberwiseInit
import SwiftUI

@MainActor @MemberwiseInit
struct NavigationLabel<Label> where Label: View {
    @Init(.internal, escaping: true) private let label: () -> Label

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
