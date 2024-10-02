//
//  DividedVStack.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/30.
//

import SwiftUI

struct DividedVStack<Content: View>: View {
    @ViewBuilder private let content: () -> Content

    init(content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        _VariadicView.Tree(ViewRoot(), content: content)
    }

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
