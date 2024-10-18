//
//  DividedVStack.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/30.
//

import MemberwiseInit
import SwiftUI

@MemberwiseInit
struct DividedVStack<Content> where Content: View {
    @Init(.internal, default: HorizontalAlignment.center) private let alignment: HorizontalAlignment
    @Init(.internal, default: nil) private let spacing: CGFloat?
    @Init(.internal, escaping: true) @ViewBuilder private let content: () -> Content

    struct ViewRoot {
        let alignment: HorizontalAlignment
        let spacing: CGFloat?
    }
}

extension DividedVStack: View {
    var body: some View {
        let viewRoot = ViewRoot(alignment: alignment, spacing: spacing)
        _VariadicView.Tree(viewRoot, content: content)
    }
}

extension DividedVStack.ViewRoot: _VariadicView_ViewRoot {
    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
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
