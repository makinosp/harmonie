//
//  NavigationSplitView+initializers.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/11.
//

import SwiftUI

extension NavigationSplitView {
    init(
        @ViewBuilder sidebar: () -> Sidebar
    ) where Content == EmptyView, Detail == EmptyView {
        self.init(sidebar: sidebar) {
            EmptyView()
        }
    }

    init(
        columnVisibility: Binding<NavigationSplitViewVisibility>,
        @ViewBuilder sidebar: () -> Sidebar
    ) where Content == EmptyView,  Detail == EmptyView {
        self.init(columnVisibility: columnVisibility, sidebar: sidebar) {
            EmptyView()
        }
    }
}
