//
//  DividedHStack.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/30.
//

import SwiftUI

struct DividedHStack<Content> where Content: View {
    private let alignment: VerticalAlignment
    private let spacing: CGFloat?
    private let content: Content

    init(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
}

extension DividedHStack: View {
    var body: some View {
        let viewRoot = ViewRoot(alignment: alignment, spacing: spacing)
        _VariadicView.Tree(viewRoot) { content }
    }
}

extension DividedHStack {
    struct ViewRoot: _VariadicView_ViewRoot {
        let alignment: VerticalAlignment
        let spacing: CGFloat?
    }
}

extension DividedHStack.ViewRoot: _VariadicView_Root {
    @ViewBuilder
    func body(children: _VariadicView.Children) -> HStack<some View> {
        HStack(alignment: alignment, spacing: spacing) {
            ForEach(children) { child in
                child
                if child.id != children.last?.id {
                    Divider()
                }
            }
        }
    }
}
