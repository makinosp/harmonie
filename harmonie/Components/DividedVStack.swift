//
//  DividedVStack.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/30.
//

import MemberwiseInit
import SwiftUI

struct DividedVStack<Content> where Content: View {
    @Init(escaping: true) @ViewBuilder private let content: () -> Content

    private struct ViewRoot: _VariadicView_ViewRoot {
        @ViewBuilder func body(children: _VariadicView.Children) -> some View {
            VStack {
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

extension DividedVStack: View {
    var body: some View {
        _VariadicView.Tree(ViewRoot(), content: content)
    }
}
