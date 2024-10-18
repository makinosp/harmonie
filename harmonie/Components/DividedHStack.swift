//
//  DividedHStack.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/30.
//

import MemberwiseInit
import SwiftUI

@MemberwiseInit
struct DividedHStack<Content> where Content: View {
    @Init(.internal, default: VerticalAlignment.center) private let alignment: VerticalAlignment
    @Init(.internal, default: nil) private let spacing: CGFloat?
    @Init(.internal, escaping: true) @ViewBuilder private let content: () -> Content

    struct ViewRoot: _VariadicView_ViewRoot {
        let alignment: VerticalAlignment
        let spacing: CGFloat?
    }
}

extension DividedHStack: View {
    var body: some View {
        let viewRoot = ViewRoot(alignment: alignment, spacing: spacing)
        _VariadicView.Tree(viewRoot) { content() }
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
