//
//  NavigationLabel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/22.
//

import SwiftUI

struct NavigationLabel<Label>: View where Label: View {
    private let label: () -> Label

    init(label: @escaping () -> Label) {
        self.label = label
    }

    var body: some View {
        LabeledContent(content: content, label: label)
    }

    @ViewBuilder
    func content() -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad {
            Constants.IconSet.forward.icon
                .foregroundStyle(Color(.tertiaryLabel))
                .imageScale(.small)
        }
    }
}
