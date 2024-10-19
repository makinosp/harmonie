//
//  DividedVStack.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/30.
//

import SwiftUI

struct DividedVStack<Content> where Content: View {
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let content: Content

    init(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
}

extension DividedVStack: View {
    var body: some View {
        let viewRoot = ViewRoot(alignment: alignment, spacing: spacing)
        _VariadicView.Tree(viewRoot) { content }
    }
}

extension DividedVStack {
    struct ViewRoot: _VariadicView_ViewRoot {
        let alignment: HorizontalAlignment
        let spacing: CGFloat?
    }
}

extension DividedVStack.ViewRoot: _VariadicView_Root {
    @ViewBuilder
    func body(children: _VariadicView.Children) -> VStack<some View> {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(children) { child in
                child
                if child.id != children.last?.id {
                    Divider()
                }
            }
        }
    }
}
