//
//  DividedHStack.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/30.
//

import MemberwiseInit
import SwiftUI

struct DividedHStack<Content> where Content: View {
    @Init(escaping: true) @ViewBuilder private let content: () -> Content

    private struct ViewRoot: _VariadicView_ViewRoot {
        @ViewBuilder func body(children: _VariadicView.Children) -> some View {
            HStack {
                ForEach(children) { child in
                    child
                    if child.id != children.last?.id {
                        Divider()
                    }
                }
            }
        }
    }
}

extension DividedHStack: View {
    var body: some View {
        _VariadicView.Tree(ViewRoot(), content: content)
    }
}
